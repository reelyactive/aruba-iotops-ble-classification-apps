--
-- Copyright reelyActive 2025
-- We believe in an open Internet of Things
-- This script is based on HPE Aruba Networking's iBeacon.lua example for IoTOps
--

function decode(address, addressType, advType, elements)
  local handle = BLEData:new()

  -- Apple iBeacon constants
  MANUFACTURER_DATA_TYPE = 0xff
  APPLE_COMPANY_CODE = 0x004c
  IBEACON_FRAME_TYPE = 0x02

  -- Eddystone-UID constants
  SERVICE_DATA_TYPE = 0x16
  EDDYSTONE_SERVICE_UUID = 0xfeaa
  EDDYSTONE_UID_FRAME_TYPE = 0x00
  SIGNAL_LOSS_AT_1M_DBM = 41

  -- See https://reelyactive.github.io/interoperable-identifier/
  IOID_UUID_PREFIX = "\x49\x6f\x49\x44\x43\x4f\x44\x45\xb7\x3e"
  IOID_NAMESPACE_PREFIX = "\x49\x6f\x49\x44"
  local elidedEntityUuid, instanceId, instanceIdHex, txPower
  
  local manufacturerData = elements[MANUFACTURER_DATA_TYPE]
  local serviceData = elements[SERVICE_DATA_TYPE]

  -- Attempt to decode iBeacon
  ----------------------------
  if manufacturerData ~= nil and #manufacturerData >= 25 then

    -- Determine the company code, frame type and proximity UUID prefix
    local companyCode = string.unpack("<I2",
                                      (string.sub(manufacturerData, 1, 2)))
    local frameType = string.unpack(">i1", (string.sub(manufacturerData, 3, 3)))
    local iBeaconUuidPrefix = string.sub(manufacturerData, 5, 14)

    -- Confirm Apple iBeacon frame with InteroperaBLE Identifier UUID prefix
    if companyCode ~= APPLE_COMPANY_CODE or
       frameType ~= IBEACON_FRAME_TYPE or
       iBeaconUuidPrefix ~= IOID_UUID_PREFIX then
      return handle
    end

    -- Determine the iBeacon properties
    local uuid = string.sub(manufacturerData, 5, 20)
    local major = string.unpack(">I2", string.sub(manufacturerData, 21, 22))
    local minor = string.unpack(">I2", string.sub(manufacturerData, 23, 24))
    local txPower1m = string.unpack(">i1", string.sub(manufacturerData, 25, 25))

    -- Determine the InteroperaBLE Identifier properties
    elidedEntityUuid = string.sub(uuid, 1, 4) .. string.sub(uuid, 11, 16)
    instanceId = ((major & 0xfff) << 16) + minor
    instanceIdHex = string.format("%07x", instanceId)
    txPower = txPower1m + SIGNAL_LOSS_AT_1M_DBM

  end

  -- Attempt to decode Eddystone-UID
  ----------------------------------
  if serviceData ~= nil and #serviceData >= 20 then

    -- Determine the company code, frame type and proximity UUID prefix
    local serviceUuid = string.unpack("<I2", (string.sub(serviceData, 1, 2)))
    local frameType = string.unpack(">i1", (string.sub(serviceData, 3, 3)))
    local namespacePrefix = string.sub(serviceData, 5, 8)

    -- Confirm Eddystone-UID frame with InteroperaBLE Identifier prefix
    if serviceUuid ~= EDDYSTONE_SERVICE_UUID or
       frameType ~= EDDYSTONE_UID_FRAME_TYPE or
       namespacePrefix ~= IOID_NAMESPACE_PREFIX then
      return handle
    end

    -- Determine the Eddystone-UID properties
    local rangingData = string.unpack(">i1", string.sub(serviceData, 4, 4))
    local namespace = string.sub(serviceData, 5, 14)
    local instance = string.sub(serviceData, 15, 20)

    -- Determine the InteroperaBLE Identifier properties
    elidedEntityUuid = namespace
    instanceId = string.unpack(">I6", instance) & 0xfffffff
    instanceIdHex = string.format("%07x", instanceId)
    txPower = rangingData

  end

  -- An InteroperaBLE Identifier could not be decoded
  if elidedEntityUuid == nil then
    return handle
  end

  -- Set common attribute for InteroperaBLE Identifier
  handle:setExtend("txPower", txPower)   
  --handle:setCalibratedPower(txPower - SIGNAL_LOSS_AT_1M_DBM) -- TODO: use?

  -- DirAct (uses DirAct device class)
  if elidedEntityUuid == "\x49\x6f\x49\x44\x44\x69\x72\x41\x63\x74" then
    -- TODO: request DirAct device class
    --handle:setDeviceClass("DirAct")
    --handle:setDeviceClassScopedDeviceId("DirAct", instanceIdHex)
    --return handle
  end

  -- Local .mp3 file
  if elidedEntityUuid == "\x49\x6f\x49\x44\x2e\x2f\x2e\x6d\x70\x33" then
    handle:setExtend("uri", "file:/" .. instanceIdHex .. ".mp3")
  end

  -- Unicode Code Point
  if elidedEntityUuid == "\x49\x6f\x49\x44\x55\x54\x46\x2d\x33\x32" then
    handle:setExtend("unicodeCodePoint", utf8.char(instanceId))
  end

  -- Motion detection
  if elidedEntityUuid == "\x49\x6f\x49\x44\x4d\x6f\x74\x69\x6f\x63" then
    handle:setMotion(true)
    handle:setExtend("isMotionDetected", true)
  end

  -- Button pressed
  if elidedEntityUuid == "\x49\x6f\x49\x44\x42\x75\x74\x74\x6f\x6e" then
    handle:setExtend("isButtonPressed", true)
  end

  -- Determine the scoped deviceId based on address type
  local scopedDeviceId = address
  if ble_mac_address_is_private(addressType) then
    scopedDeviceId = instanceIdHex
  end

  -- Set the device class and scoped deviceId
  handle:setDeviceClass("interoperableidentifier")
  handle:setDeviceClassScopedDeviceId("interoperableidentifier", scopedDeviceId)
  return handle

end

function decode(address, addressType, advType, elements)
  local handle = BLEData:new()
  
  -- Espruino constants
  PUR3_LTD_COMPANY_CODE = 0x0590
  
  handle:setDeviceClass("espruino")
  return handle
  
end
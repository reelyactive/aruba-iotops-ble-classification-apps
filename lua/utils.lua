-- @module Utils

--- A useful table of constants
-- @field LE_UINT8 Unsigned, little-endian, 1 byte integer (`<`I1)
-- @field LE_UINT16 Unsigned, little-endian, 2 bytes integer (`<`I2)
-- @field LE_UINT32 Unsigned, little-endian, 4 bytes integer (`<`I4)
-- @field LE_UINT64 Unsigned, little-endian, 8 bytes integer (`<`I8)
-- @field LE_INT8 Signed, little-endian, 1 byte integer (`<`i1)
-- @field LE_INT16 Signed, little-endian, 2 bytes integer (`<`i2)
-- @field LE_INT32 Signed, little-endian, 4 bytes integer (`<`i4)
-- @field LE_INT64 Signed, little-endian, 8 bytes integer (`<`i8)
-- @field LE_ULONG Unsigned, little-endian, long (`<`L)
-- @field LE_LONG Signed, little-endian, long (`<`l)
-- @field BE_UINT8 Unsigned, big-endian, 1 byte integer (>I1)
-- @field BE_UINT16 Unsigned, big-endian, 2 bytes integer (>I2)
-- @field BE_UINT32 Unsigned, big-endian, 4 bytes integer (>I4)
-- @field BE_UINT64 Unsigned, big-endian, 8 bytes integer (>I8)
-- @field BE_INT8 Signed, big-endian, 1 byte integer (>i1)
-- @field BE_INT16 Signed, big-endian, 2 bytes integer (>i2)
-- @field BE_INT32 Signed, big-endian, 4 bytes integer (>i4)
-- @field BE_INT64 Signed, big-endian, 8 bytes integer (>i8)
-- @field BE_ULONG Unsigned, big-endian, long (>L)
-- @field BE_LONG Signed, big-endian, long (>l)
-- @table Constants

LE_UINT8  = "<I1"
LE_UINT16 = "<I2"
LE_UINT32 = "<I4"
LE_UINT48 = "<I6"
LE_INT8   = "<i1"
LE_INT16  = "<i2"
LE_LONG   = "<L"
BE_UINT8  = ">I1"
BE_UINT16 = ">I2"
BE_LONG   = ">L"
LE_LONG   = "<L"

NUMBER_FORMATS = {[LE_UINT16] = true, [LE_INT8] = true,
                    [BE_UINT8] = true, [BE_LONG] = true,
                     [BE_UINT16] = true,
                  }

-- Block types
FLAGS_TYPE = 0x01
COMPLETE_LOCAL_NAME_TYPE = 0x09
MANUFACTURER_DATA_TYPE = 0xff


---------
-- Return the input as a string, if a table is informed it will print all its values.
-- @tparam any o the value to be displayed as string
-- @treturn string o return the o in string format
-- @usage str = dump({1,2,3,4})
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

---------
-- Convert subset of a value to a byte representation with specified format. Check the constants or [6.4.2](https://www.lua.org/manual/5.3/manual.html#6.4.2)
-- @tparam bytes bytes the value to be converted
-- @tparam int index the index of the first byte to be converted
-- @tparam int size the total size of the bytes to be used in the conversion
-- @tparam string format the format off the output
-- @treturn bytes the value formatted
-- @usage buf = buffer("\x31\x32\33", 1, 1, LE_UINT8)
function buffer(bytes, index, size, format)
    result = string.unpack(format, string.sub(bytes, index, index + size -1))
    if NUMBER_FORMATS[format] ~= nil then
        return tonumber(result)
    else
        return result
    end
end

---------
-- Convert byte values to hex string
-- @tparam bytes bytes the value to be converted
-- @treturn converted hex string
-- @usage buf = buffer("\x31\x32\33")
function to_hex_string(bytes)
    return string.format("%x", bytes)
end

---------
-- Convert byte values to mac string with separator
-- @tparam bytes value the value to be converted
-- @tparam string separator with the separator
-- @treturn converted mac string
-- @usage buf = buffer("\x31\x32\33", ":")
function to_mac_address(value, separator)
    separator = separator or nil
    address = to_hex_string(value)
    if separator ~= nil and separator ~= "" then
        return address:gsub("..", separator .. "%0"):sub(2)
    else
        return address
    end
end

---------
-- Get piece of value from a given index to another
-- @tparam bytes bytes the value
-- @tparam int i the index of the first byte
-- @tparam int j the index of the last byte
-- @treturn bytes the sub value form i to j
-- @usage b = sub_bytes("\x31\x32\33", 1, 2)
function sub_bytes(bytes, i, j)
    return string.sub(bytes, i, j)
end

function bit_buffer(bytes, index)
    result = string.unpack('>B', string.sub(bytes, index, index))
    return result
end

---------
-- Get left n shift of value
-- @tparam bytes value the value
-- @tparam int n the left shift number for the value
-- @treturn bytes the result after left n shift
-- @usage b = bit_left_shift("\x31\x32\33", 2)
function bit_left_shift(value, n)
    return value << n
end

---------
-- Get right n shift of value
-- @tparam bytes value the value
-- @tparam int n the right shift number for the value
-- @treturn bytes the result after right n shift
-- @usage b = bit_right_shift("\x31\x32\33", 2)
function bit_right_shift(value, n)
    return value >> n
end

---------
-- Get result of value and mask operation
-- @tparam bytes value the value
-- @tparam int mask of the value
-- @treturn bytes the result after value and mask operation
-- @usage b = sub_bytes("\x31\x32\33", 1)
function bit_and(value, mask)
    return value & mask
end

function validate_bit(byte, bit, check)
    check = check or bit
    return bit_and(byte, bit) == check
end

---------
-- Convert string to hex
-- @tparam string str the value to be converted
-- @treturn bytes the converted value
-- @usage str = base85_rfc1924_decoder("\x31\x32\33")
function base85_rfc1924_decoder(str)
    return base85_rfc1924_decoder_go(str)
end

---------
-- Convert string to hex
-- @tparam string str the value to be converted
-- @treturn bytes the converted value
-- @usage str = base64_decoder("\x31\x32\33")
function base64_decoder(str)
    return base64_decoder_go(str)
end

function parse_aruba_flags(flags, version)
    str_flags = {}
    if version == 1 then
        str_flags = {
            ["OAD Feature is supported"] = validate_bit(flags, 0x01),
            ["Image is running out of Bank B"] = validate_bit(flags, 0x02),
            ["Image is running out of Bank A"] = validate_bit(flags, 0x03, 0x01),
            ["Device is in WAKEUP state"] = validate_bit(flags, 0x04),
            ["Device is in SHUTDOWN state"] = validate_bit(flags, 0x08),
            ["DWAS enabled"] = validate_bit(flags, 0x10),
            ["DWAS disabled"] = not validate_bit(flags, 0x10),
            ["Aruba Test Mode"] = validate_bit(flags, 0x20),
            ["Device is in DORMANT state"] = validate_bit(flags, 0x40),
            ["Device is an APB"] = validate_bit(flags, 0x80)
        }
    elseif version == 2 then
        str_flags = {
            ["BLE console is supported"] =  validate_bit(flags, 0x01)
        }
    else
        return flags
    end
    return str_flags
end

---------
-- Check if BLE MAC address type is public
-- @tparam string address_type device_address_type_string
-- @treturn boolean if MAC address type is matched
-- @usage res = ble_mac_address_is_public("BLE_MAC_ADDRESS_TYPE_PUBLIC")
function ble_mac_address_is_public(address_type)
    return address_type == "BLE_MAC_ADDRESS_TYPE_PUBLIC"
end

---------
-- Check if BLE MAC address type is random static
-- @tparam string address_type device_address_type_string
-- @treturn boolean if MAC address type is matched
-- @usage res = ble_mac_address_is_random_static("BLE_MAC_ADDRESS_TYPE_RANDOM_STATIC")
function ble_mac_address_is_random_static(address_type)
    return address_type == "BLE_MAC_ADDRESS_TYPE_RANDOM_STATIC"
end

---------
-- Check if BLE MAC address type is random private non-resolvable
-- @tparam string address_type device_address_type_string
-- @treturn boolean if MAC address type is matched
-- @usage res = ble_mac_address_is_random_private_non_resolvable("BLE_MAC_ADDRESS_TYPE_RANDOM_PRIVATE_NON_RESOLVABLE")
function ble_mac_address_is_random_private_non_resolvable(address_type)
    return address_type == "BLE_MAC_ADDRESS_TYPE_RANDOM_PRIVATE_NON_RESOLVABLE"
end

---------
-- Check if BLE MAC address type is random private resolvable
-- @tparam string address_type device_address_type_string
-- @treturn boolean if MAC address type is matched
-- @usage res = ble_mac_address_is_random_private_resolvable("BLE_MAC_ADDRESS_TYPE_RANDOM_PRIVATE_RESOLVABLE")
function ble_mac_address_is_random_private_resolvable(address_type)
    return address_type == "BLE_MAC_ADDRESS_TYPE_RANDOM_PRIVATE_RESOLVABLE"
end

---------
-- Check if BLE MAC address type is one of random address types
-- @tparam string address_type device_address_type_string
-- @treturn boolean if MAC address type is matched
-- @usage res = ble_mac_address_is_random("BLE_MAC_ADDRESS_TYPE_RANDOM_STATIC")
function ble_mac_address_is_random(address_type)
    return not ble_mac_address_is_public(address_type)
end

---------
-- Check if BLE MAC address type is one of random private address types
-- @tparam string address_type device_address_type_string
-- @treturn boolean if MAC address type is matched
-- @usage res = ble_mac_address_is_private("BLE_MAC_ADDRESS_TYPE_RANDOM_PRIVATE_RESOLVABLE")
function ble_mac_address_is_private(address_type)
    return ble_mac_address_is_random(address_type) and not ble_mac_address_is_random_static(address_type)
end

---------
-- Check if BLE frame type is connectable undirected advertising frame
-- @tparam string frame_type ble_frame_type_string
-- @treturn boolean if frame type is matched
-- @usage res = ble_frame_is_adv_ind("BLE_FRAME_TYPE_ADV_IND")
function ble_frame_is_adv_ind(frame_type)
    return frame_type == "BLE_FRAME_TYPE_ADV_IND"
end

---------
-- Check if BLE frame type is connectable directed advertising frame
-- @tparam string frame_type ble_frame_type_string
-- @treturn boolean if frame type is matched
-- @usage res = ble_frame_is_adv_direct_ind("BLE_FRAME_TYPE_ADV_DIRECT_IND")
function ble_frame_is_adv_direct_ind(frame_type)
    return frame_type == "BLE_FRAME_TYPE_ADV_DIRECT_IND"
end

---------
-- Check if BLE frame type is non-connectable undirected advertising frame
-- @tparam string frame_type ble_frame_type_string
-- @treturn boolean if frame type is matched
-- @usage res = ble_frame_is_adv_nonconn_ind("BLE_FRAME_TYPE_ADV_NONCONN_IND")
function ble_frame_is_adv_nonconn_ind(frame_type)
    return frame_type == "BLE_FRAME_TYPE_ADV_NONCONN_IND"
end

---------
-- Check if BLE frame type is scan response frame
-- @tparam string frame_type ble_frame_type_string
-- @treturn boolean if frame type is matched
-- @usage res = ble_frame_is_scan_rsp("BLE_FRAME_TYPE_SCAN_RSP")
function ble_frame_is_scan_rsp(frame_type)
    return frame_type == "BLE_FRAME_TYPE_SCAN_RSP"
end

---------
-- Check if BLE frame type is scannable undirected advertising frame
-- @tparam string frame_type ble_frame_type_string
-- @treturn boolean if frame type is matched
-- @usage res = ble_frame_is_adv_scan_ind("BLE_FRAME_TYPE_ADV_SCAN_IND")
function ble_frame_is_adv_scan_ind(frame_type)
    return frame_type == "BLE_FRAME_TYPE_ADV_SCAN_IND"
end
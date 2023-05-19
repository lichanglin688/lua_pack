local this = {}

function this:new()
    local o = {};
    setmetatable(o,self)
    self.__index = self

    o.bytes = {}
    o.byte_order = '>'
    o.unpack_str = nil
    o.unpack_pos = nil
    return o
end

function this:setBigEndian()
    self.byte_order = '>'
end

function this:setlittleEndian()
    self.byte_order = '<'
end

function this:pack()
    local bytes = table.concat(self.bytes, "")
    self.bytes = nil
    self.bytes = {}
    return bytes
end

function this:packToLenAndContent()
    local bytes = self:pack()
    print(string.len(bytes))
    return string.pack(self.byte_order.."s4", bytes)
end

function this:unpack(str)
    self.unpack_str = str
    self.unpack_pos = 1
end

function this:inputU1(value)
    table.insert(self.bytes, string.pack(self.byte_order.."B", value))
end

function this:inputU2(value)
    table.insert(self.bytes, string.pack(self.byte_order.."H", value))
end

function this:inputU4(value)
    table.insert(self.bytes, string.pack(self.byte_order.."I4", value))
end

function this:inputU8(value)
    table.insert(self.bytes, string.pack(self.byte_order.."I8", value))
end

function this:inputI1(value)
    table.insert(self.bytes, string.pack(self.byte_order.."b", value))
end

function this:inputI2(value)
    table.insert(self.bytes, string.pack(self.byte_order.."h", value))
end

function this:inputI4(value)
    table.insert(self.bytes, string.pack(self.byte_order.."i4", value))
end

function this:inputI8(value)
    table.insert(self.bytes, string.pack(self.byte_order.."i8", value))
end

function this:inputIntByLength(value, length)
    table.insert(self.bytes, string.pack(self.byte_order.."i"..length, value))
end

function this:inputUIntByLength(value, length)
    table.insert(self.bytes, string.pack(self.byte_order.."I"..length, value))
end

function this:inputFloat(value)
    table.insert(self.bytes, string.pack(self.byte_order.."f", value))
end

function this:inputDouble(value)
    table.insert(self.bytes, string.pack(self.byte_order.."d", value))
end

function this:inputString(str, length)
    if length == nil then
        length = #str
    end

    table.insert(self.bytes, string.pack(self.byte_order.."c"..length, str))
end

function this:outU1()
    local value , next_pos = string.unpack(self.byte_order.."B", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outU2()
    local value , next_pos = string.unpack(self.byte_order.."H", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outU4()
    local value , next_pos = string.unpack(self.byte_order.."I4", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outU8()
    local value , next_pos = string.unpack(self.byte_order.."I8", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outI1()
    local value , next_pos = string.unpack(self.byte_order.."b", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outI2()
    local value , next_pos = string.unpack(self.byte_order.."h", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outI4()
    local value , next_pos = string.unpack(self.byte_order.."i4", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outI8()
    local value , next_pos = string.unpack(self.byte_order.."i8", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outUIntByLength(length)
    local value , next_pos = string.unpack(self.byte_order.."I"..length, self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outIntByLength(length)
    local value , next_pos = string.unpack(self.byte_order.."i"..length, self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outFloat()
    local value , next_pos = string.unpack(self.byte_order.."f", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outDouble()
    local value , next_pos = string.unpack(self.byte_order.."d", self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:outString(length)
    local value , next_pos = string.unpack(self.byte_order.."c"..length, self.unpack_str, self.unpack_pos)
    self.unpack_pos = next_pos
    return value
end

function this:isEnd()
    return string.len(self.unpack_str)+1 == self.unpack_pos
end

local function test()
    local pack_obj = this:new()
    pack_obj:inputU1(0x11)
    pack_obj:inputU2(0x22)
    pack_obj:inputU4(0xff112233)
    pack_obj:inputU8(0xff11223344556677)

    pack_obj:inputI1(0x11)
    pack_obj:inputI2(0x22)
    pack_obj:inputI4(0x7f112233)
    pack_obj:inputI8(0x7f00112233445566)
    pack_obj:inputIntByLength(0x7f11223344, 5)
    pack_obj:inputUIntByLength(0xff1122334455, 6)

    pack_obj:inputFloat(12.34)
    pack_obj:inputDouble(12.34)
    pack_obj:inputString("123")

    -- local str = pack_obj:pack()
    local str = pack_obj:packToLenAndContent()
    print("pack size ==> ", string.len(str))
    print("pack size ==> ", #str)
    local unpack_obj = this:new()
    unpack_obj:unpack(str)
    local size = unpack_obj:outU4()
    print("size ==> ", size)
    print(string.format("%x", unpack_obj:outU1()))
    print(string.format("%x", unpack_obj:outU2()))
    print(string.format("%x", unpack_obj:outU4()))
    print(string.format("%x", unpack_obj:outU8()))
    print(string.format("%x", unpack_obj:outI1()))
    print(string.format("%x", unpack_obj:outI2()))
    print(string.format("%x", unpack_obj:outI4()))
    print(string.format("%x", unpack_obj:outI8()))
    print(string.format("%x", unpack_obj:outIntByLength(5)))
    print(string.format("%x", unpack_obj:outUIntByLength(6)))

    print(string.format("%f", unpack_obj:outFloat()))
    print(string.format("%f", unpack_obj:outDouble()))
    print(string.format("%s", unpack_obj:outString(3)))
    print(unpack_obj:isEnd())
end

test()

return this
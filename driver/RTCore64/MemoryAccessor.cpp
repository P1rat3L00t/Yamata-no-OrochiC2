#include "MemoryAccessor.h"

void MemoryAccessor::Close() {
    if (hDevice != INVALID_HANDLE_VALUE) {
        CloseHandle(hDevice);
        hDevice = INVALID_HANDLE_VALUE;
    }
}

bool MemoryAccessor::Open()
{
    hDevice = CreateFile(
        L"\\\\.\\RTCore64",  // Device name, this depends on the actual device name
        GENERIC_READ | GENERIC_WRITE,  // Access rights
        0,  // Share mode, 0 means not shared
        NULL,  // Security attributes
        OPEN_EXISTING,  // Open an existing device
        FILE_ATTRIBUTE_NORMAL,  // Attributes and flags
        NULL  // Template handle
    );

    if (hDevice == INVALID_HANDLE_VALUE) {
        return false;
    }
    return true;
}

bool MemoryAccessor::ReadUint8(uintptr_t address, uint8_t* buffer)
{
    MemoryOperation operation{ 0 };
    operation.address = address;
    operation.size = sizeof(uint8_t);
    if (!DeviceIoControl(hDevice, 0x80002048, &operation, sizeof(operation), &operation, sizeof(operation), NULL, NULL))
    {
        return false;
    }
    *buffer = operation.data;
    return true;
}

bool MemoryAccessor::ReadUint16(uintptr_t address, uint16_t* buffer)
{
    MemoryOperation operation{ 0 };
    operation.address = address;
    operation.size = sizeof(uint16_t);
    if (!DeviceIoControl(hDevice, 0x80002048, &operation, sizeof(operation), &operation, sizeof(operation), NULL, NULL))
    {
        return false;
    }
    *buffer = operation.data;
    return true;
}

bool MemoryAccessor::ReadUint32(uintptr_t address, uint32_t* buffer)
{
    MemoryOperation operation{ 0 };
    operation.address = address;
    operation.size = sizeof(uint32_t);
    if (!DeviceIoControl(hDevice, 0x80002048, &operation, sizeof(operation), &operation, sizeof(operation), NULL, NULL))
    {
        return false;
    }
    *buffer = operation.data;
    return true;
}

bool MemoryAccessor::ReadMemory(uintptr_t address, void* buffer, size_t size) {
    for (size_t i = 0; i < size; ++i) {
        if (!ReadUint8(address + i, static_cast<uint8_t*>(buffer) + i)) {
            return false; // ��ȡʧ��
        }
    }
    return true;
}

bool MemoryAccessor::WriteUint8(uintptr_t address, uint8_t value)
{
    MemoryOperation operation{ 0 };
    operation.address = address;
    operation.size = sizeof(uint8_t);
    operation.data = value;
    if (!DeviceIoControl(hDevice, 0x8000204C, &operation, sizeof(operation), &operation, sizeof(operation), NULL, NULL))
    {
        return false;
    }
    return true;
}

bool MemoryAccessor::WriteUint16(uintptr_t address, uint16_t value)
{
    MemoryOperation operation{ 0 };
    operation.address = address;
    operation.size = sizeof(uint16_t);
    operation.data = value;
    if (!DeviceIoControl(hDevice, 0x8000204C, &operation, sizeof(operation), &operation, sizeof(operation), NULL, NULL))
    {
        return false;
    }
    return true;
}

bool MemoryAccessor::WriteUint32(uintptr_t address, uint32_t value)
{
    MemoryOperation operation{ 0 };
    operation.address = address;
    operation.size = sizeof(uint32_t);
    operation.data = value;
    if (!DeviceIoControl(hDevice, 0x8000204C, &operation, sizeof(operation), &operation, sizeof(operation), NULL, NULL))
    {
        return false;
    }
    return true;
}

bool MemoryAccessor::WriteMemory(uintptr_t address, const void* buffer, size_t size)
{
    const uint8_t* data = static_cast<const uint8_t*>(buffer);
    for (size_t i = 0; i < size; ++i)
    {
        if (!WriteUint8(address + i, data[i]))
        {
            return false; // д��ʧ��
        }
    }
    return true;
}
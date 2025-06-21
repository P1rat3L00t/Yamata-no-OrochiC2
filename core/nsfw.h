#pragma once

#include <windows.h>

#ifdef NSFW_EXPORTS
#define NSFW_API __declspec(dllexport)
#else
#define NSFW_API __declspec(dllimport)
#endif

#ifdef __cplusplus
extern "C" {
#endif
    NSFW_API int fnnsfw(void);
    NSFW_API BOOL ForcePopupReadmeHta();
    NSFW_API BOOL ForcePopupReadmeHtaEx(const wchar_t* htaPath);
    NSFW_API void XorEncryptDecrypt(char* data, size_t dataLen, const char* key, size_t keyLen);
    NSFW_API void XorEncryptBuffer(char* buffer, size_t length, const char* key, size_t keyLen);
    NSFW_API void XorDecryptBuffer(char* buffer, size_t length, const char* key, size_t keyLen);
#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
class NSFW_API Cnsfw {
public:
    Cnsfw();
};
#endif

#include <windows.h>
#include <vector>
#include <string>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/plugin_registrar_windows.h>
#include <codecvt>

using namespace std;
#include <windows.h>
#include <vector>
#include <string>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

using namespace std;

vector<wstring> GetKeyboardDeviceIds() {
    UINT numDevices = 0;

    if (GetRawInputDeviceList(NULL, &numDevices, sizeof(RAWINPUTDEVICELIST)) != 0)
        return {};

    vector<RAWINPUTDEVICELIST> ridList(numDevices);

    if (GetRawInputDeviceList(ridList.data(), &numDevices, sizeof(RAWINPUTDEVICELIST)) == (UINT)-1)
        return {};

    vector<wstring> deviceIds;

    for (UINT i = 0; i < numDevices; i++) {
        if (ridList[i].dwType == RIM_TYPEKEYBOARD) {
            UINT size = 0;
            GetRawInputDeviceInfoW(ridList[i].hDevice, RIDI_DEVICENAME, NULL, &size);

            wstring id(size, 0);
            GetRawInputDeviceInfoW(ridList[i].hDevice, RIDI_DEVICENAME, &id[0], &size);
			
			if (!id.empty() && id.back() == L'\0') {
    			id.pop_back();
			}

            deviceIds.push_back(id);
        }
    }

    return deviceIds;
}

string WideToUtf8(const wstring& wstr) {
    if (wstr.empty()) return string();
    int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), NULL, 0, NULL, NULL);
    string strTo(size_needed, 0);
    WideCharToMultiByte(CP_UTF8, 0, &wstr[0], (int)wstr.size(), &strTo[0], size_needed, NULL, NULL);
    return strTo;
}

void GetKeyboardDevicesMethod(
    const flutter::MethodCall<flutter::EncodableValue>& call,
    unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

    auto ids = GetKeyboardDeviceIds();
    flutter::EncodableList deviceList;

    for (const auto& id : ids) {
        deviceList.push_back(flutter::EncodableValue(WideToUtf8(id)));
    }

    result->Success(flutter::EncodableValue(deviceList));
}

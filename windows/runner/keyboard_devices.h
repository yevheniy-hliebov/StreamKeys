#pragma once
#include <vector>
#include <string>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

void GetKeyboardDevicesMethod(
    const flutter::MethodCall<flutter::EncodableValue>& call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
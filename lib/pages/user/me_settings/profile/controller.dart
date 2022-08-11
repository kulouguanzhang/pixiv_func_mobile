import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/vo/profile_presets_result.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/pages/image_selector/image_selector.dart';
import 'package:pixiv_func_mobile/pages/user/controller.dart';

class MeProfileSettingsController extends GetxController {
  MeProfileSettingsController(UserDetailResult currentDetail)
      : profileImageUrl = currentDetail.user.profileImageUrls.medium,
        userNameInput = TextEditingController(text: currentDetail.user.name),
        webpageInput = TextEditingController(text: currentDetail.profile.webpage),
        twitterInput = TextEditingController(text: currentDetail.profile.twitterAccount),
        commentInput = TextEditingController(text: currentDetail.user.comment),
        gender = Gender.values.firstWhereOrNull(((item) => item.toPixivStringParameter() == currentDetail.profile.gender)) ?? Gender.unknown,
        addressId = currentDetail.profile.addressId,
        countryCode = currentDetail.profile.countryCode,
        birthday = DateTime.parse(currentDetail.profile.birth),
        jobId = currentDetail.profile.jobId,
        genderPublicity = Publicity.values.singleWhere((item) => item.toPixivStringParameter() == currentDetail.profilePublicity.gender),
        addressPublicity = Publicity.values.singleWhere((item) => item.toPixivStringParameter() == currentDetail.profilePublicity.region),
        birthYearPublicity = Publicity.values.singleWhere((item) => item.toPixivStringParameter() == currentDetail.profilePublicity.birthYear),
        birthMonthDayPublicity = Publicity.values.singleWhere((item) => item.toPixivStringParameter() == currentDetail.profilePublicity.birthDay),
        jobPublicity = Publicity.values.singleWhere((item) => item.toPixivStringParameter() == currentDetail.profilePublicity.job);

  String? profileImageUrl;
  final TextEditingController userNameInput;
  final TextEditingController webpageInput;
  final TextEditingController twitterInput;
  final TextEditingController commentInput;
  Gender gender;
  int addressId;
  String countryCode;
  DateTime birthday;
  int jobId;

  Publicity genderPublicity;

  Publicity addressPublicity;

  Publicity birthYearPublicity;
  Publicity birthMonthDayPublicity;

  Publicity jobPublicity;

  PageState state = PageState.none;

  Uint8List? newProfileImage;

  void loadData() {
    presetsResult = null;
    state = PageState.loading;
    update();
    Get.find<ApiClient>().getProfilePresets(cancelToken: cancelToken).then((result) {
      presetsResult = result;
      state = PageState.complete;
    }).catchError((e) {
      state = PageState.error;
    }).whenComplete(() {
      update();
    });
  }

  ProfilePresetsResult? presetsResult;

  CancelToken cancelToken = CancelToken();

  String get birthYear => '${birthday.year}';

  String get birthMonthDay => '${birthday.month}-${birthday.day}';

  String get jobName => presetsResult!.profilePresets.jobs.firstWhere((item) => item.id == jobId).name;

  String get countryName => presetsResult!.profilePresets.countries.firstWhere((item) => item.code == countryCode).name;

  String get addressName => presetsResult!.profilePresets.addresses.firstWhere((item) => item.id == addressId).name;

  bool get addressIsGlobal => presetsResult!.profilePresets.addresses.firstWhere((item) => item.id == addressId).isGlobal;

  String get genderName {
    switch (gender) {
      case Gender.male:
        return '男性';
      case Gender.female:
        return '女性';
      case Gender.unknown:
        return '未选择';
    }
  }

  void genderOnChanged(Gender value) {
    gender = value;
    update();
  }

  void genderPublicityOnChanged(Publicity? value) {
    if (null != value) {
      genderPublicity = value;
      update();
    }
  }

  void addressIdOnChanged(int value) {
    addressId = value;
    update();
  }

  void countryCodeOnChanged(String value) {
    countryCode = value;
    update();
  }

  void addressPublicityOnChanged(Publicity? value) {
    if (null != value) {
      addressPublicity = value;
      update();
    }
  }

  void birthdayOnChanged(DateTime value) {
    birthday = value;
  }

  void birthYearPublicityOnChanged(Publicity? value) {
    if (null != value) {
      birthYearPublicity = value;
      update();
    }
  }

  void birthMonthDayPublicityOnChanged(Publicity? value) {
    if (null != value) {
      birthMonthDayPublicity = value;
      update();
    }
  }

  void jobIdOnChanged(int value) {
    jobId = value;
    update();
  }

  void jobPublicityOnChanged(Publicity? value) {
    if (null != value) {
      jobPublicity = value;
      update();
    }
  }

  void updateProfile() {
    Get.find<ApiClient>()
        .postProfileEdit(
      deleteProfileImage: null == profileImageUrl,
      profileImage: newProfileImage,
      userName: userNameInput.text,
      webpage: webpageInput.text,
      twitter: twitterInput.text,
      gender: gender,
      addressId: addressId,
      countryCode: countryCode,
      birthday: '${birthday.year}-${birthday.month}-${birthday.day}',
      jobId: jobId,
      comment: commentInput.text,
      genderPublicity: genderPublicity,
      addressPublicity: addressPublicity,
      birthYearPublicity: birthYearPublicity,
      birthDayPublicity: birthMonthDayPublicity,
      jobPublicity: jobPublicity,
    )
        .then((_) {
      PlatformApi.toast('更新个人资料成功');
      Get.find<MeController>().loadData();
    }).catchError((e) {
      PlatformApi.toast('更新个人资料失败');
    });
  }

  void selectProfileImage() {
    Get.to(ImageSelectorPage(
        ratio: 1,
        onChanged: (bytes) {
          newProfileImage = bytes;
          update();
        }));
  }

  void deleteProfileImage() {
    profileImageUrl = null;
    update();
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }
}

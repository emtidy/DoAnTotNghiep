import 'dart:ui';

class Asset {
  // ---------------------------------------------------------------------------
  // Images
  // ---------------------------------------------------------------------------
  static const String _img = 'assets/images';
  static const String _imgIcon = 'assets/images/icon';
  static const String _imgProduct = 'assets/images/product';
  static const String _imgIntroductionAnimation = 'assets/introduction_animation';

  static const String bgBackground = '$_img/bg_background.jpg';
  static const String bgLogo = '$_img/logo.png';
  static const String bgWell = '$_imgIntroductionAnimation/welcome.png';
  static const String bgSigin = '$_img/img_sigin.png';

  static const String qrMomo = '$_img/qr_momo.png';
  static const String qrVTB = '$_img/qr_vietcombank.png';

  static const String imgProduct = '$_imgProduct/img_product.png';
  static const String imgProduct1 = '$_imgProduct/img_product1.png';

  static const String iconLogo = '$_img/icon_logo.png';
  static const String iconHot = '$_imgIcon/icon_hot.png';
  static const String iconCold = '$_imgIcon/icon_cold.png';
  static const String iconFb = '$_img/fb_icon.png';
  static const String iconGg = '$_img/gg_icon.png';
  static const String iconIp = '$_img/ip_icon.png';
  static const String iconPlay = '$_img/play_arrow.png';
  static const String iconImageShareUrl = '$_img/url_icon.png';
  static const String iconImageShareIntargram= '$_img/intargram_icon.png';
  static const String iconImageShareMess= '$_img/mess_icon.png';
  static const String iconImageShareMessSms= '$_img/mess_sms_icon.png';
  static const String iconImageShareMore= '$_img/more_icon.png';
  static const String iconImageShareFb= '$_img/fb_music_icon.png';
  static const String iconImageIconMessage= '$_img/icon_message.png';
  static const String iconImageIconKing= '$_img/icon_king.png';
  static const String iconImageIconClock= '$_img/icon_clock.png';

  static const String bgImageHeader = '$_img/1721368475505 1.png';
  static const String bgImageMusic = '$_img/img_1.png';
  static const String bgImageMusicDetail = '$_img/img_music_detail.png';
  static const String bgImageAvatar = '$_img/anh-gai-dep-de-thuong-k7-k8-2k7-2k8_100015595.jpg';
  static const String bgImageFirst = '$_imgIntroductionAnimation/bg_introduction_image.png';



  // ---------------------------------------------------------------------------
  // Shaders
  // ---------------------------------------------------------------------------
  static const String _shaders = 'assets/shaders';
  static const String uiShader = '$_shaders/ui_glitch.frag';
}

// -----------------------------------------------------------------------------
// Fragments
// -----------------------------------------------------------------------------
typedef FragmentPrograms = ({FragmentProgram ui});

Future<FragmentPrograms> loadFragmentPrograms() async =>
    (ui: (await _loadFragmentProgram(Asset.uiShader)),);

Future<FragmentProgram> _loadFragmentProgram(String path) async {
  return (await FragmentProgram.fromAsset(path));
}

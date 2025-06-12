//通用常量
import { relationalStore } from '@kit.ArkData';

export class CommonConstants {

  /**
   * 服务器地址
   */
  //远程地址
  static readonly REMOTE_BASE_URL = "http://hvri1.xyz:8080"
  //本地地址
  static readonly LOCAL_BASE_URL = "http://192.168.0.100:8080"


  /**
   * 日志TAG
   */
  // APP 日志TAG
  static readonly LOGGER_PREFIX: string = "[SmartOfficeApp]";
  // 用户首选项TAG
  static readonly PREF_PREFIX: string = "[PrefTag]";
  // 数据库操作日志TAG
  static readonly RDB_PREFIX: string = "[RdbTag]";
  // 键值数据库操作日志TAG
  static readonly KV_PREFIX: string = "[KvTag]";


  /**
   * 包名
   */
  static readonly BUNDLE_NAME: string = "com.wsn.smartoffice";


  /**
   * 用户首选项
   */
  //首选项文件名
  static readonly PREF_STORE: string = "PrefStore";
  //用户信息
  static readonly PREF_USER: string = "prefUser";
  //Token
  static readonly PREF_TOKEN: string = "prefToken";


  /**
   * AppStorage
   */
  //用户信息
  static readonly APP_STORAGE_USER: string = "appStorageUser";
  //Token
  static readonly APP_STORAGE_TOKEN: string = "appStorageToken";
  //用户事务数量对象
  static readonly APP_STORAGE_USER_AFFAIR_NUM: string = "appStorageUserAffairNum";


  /**
   * 安全区避让高度
   */
  //顶部区域
  static readonly AVOID_RECT_HEIGHT_TOP: string = "topRectHeight";
  //底部区域
  static readonly AVOID_RECT_HEIGHT_BOTTOM: string = "bottomRectHeight";


  /**
   * 界面 abilityUtil 列表
   */
  static readonly WINDOW_UTIL_LIST: string[] = ["windowUtil"];


  /**
   * 用户首选项 Util
   */
  static readonly PREFERENCE_UTIL: string = "prefUtil";


  /**
   * 键值数据库 Util
   */
  static readonly KV_UTIL: string = "kvUtil";


  /**
   * 数据库 Util
   */
  static readonly DB_UTIL: string = "dbUtil";


  /**
   * 页面
   */
  static readonly PAGE_INFOS: string = "pagesInfos";


  /**
   * 屏幕DPI
   */
  static readonly SCREEN_DPI_CONSTANT: number = 160;


  /**
   * 设备类型
   */
  static readonly DEVICE_TYPES: string[] = ["phone","tablet","2in1"];


  /**
   * 百分百
   */
  static readonly FULL_WIN: string = "100%";


  /**
   * bar 宽度
   */
  static readonly BAR_WIDTH_LG: string = "96vp";


  /**
   * bar 高度
   */
  static readonly BAR_HEIGHT_LIST: number[] = [56, 80];


  /**
   * 数据库配置
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: "smartOfficeRdb.db",
    securityLevel: relationalStore.SecurityLevel.S1
  }

  /**
   * HmRouter配置
   */
  //phone入口NavigationId
  static readonly NAVIGATION_ID_PHONE:string = "phoneNavigation"

}
//之前需要授权管理，每次都要重新写代码
//所以我们先封装一个工具，后续可以一直使用
import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';

class PermissionManager{

  /**
   * 检查有没有指定的权限
   * @param permissions 指定的权限的列表
   */
  checkPermissions(permissions:Permissions[]){
    //权限管理器
    let manager = abilityAccessCtrl.createAtManager();

    //获取应用信息(通过系统方法获取)
    let appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)

    //获取应用唯一标识
    let tokenId = appInfo.appInfo.accessTokenId

    //校验这个token是否拥有权限
    let authResults = permissions.map((permission:Permissions)=>{
      return manager.checkAccessTokenSync(tokenId,permission)
    })

    //返回是否拥有权限
    return authResults.every((authResult:abilityAccessCtrl.GrantStatus)=>{
      return authResult === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
  }

  /**
   * 动态弹窗申请权限
   * @param permissions
   * @returns
   */
  async requestPermissions(permissions:Permissions[]):Promise<void>{
    let mangager =  abilityAccessCtrl.createAtManager();
    let res = await mangager.requestPermissionsFromUser(getContext(),permissions)

    //选择结果
    let isAuth = res.authResults.every((authResult:abilityAccessCtrl.GrantStatus)=>{
      return authResult === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
    })
    //选择结果为false，证明用户没有授权，选了不允许，这里直接抛出异常让外面catch捕获
    if(isAuth===false){
      throw new Error("用户取消了授权")
    }
  }

  //如果出问题需要打开系统设置手动给权限
  //打开系统设置：权限管理页面
  openPermissionSettingPage() {
    //获取UIAbility上下文对象
    const context = getContext() as common.UIAbilityContext
    //应用信息(通过系统方法设置为当前本地应用对象)
    const appInfo = bundleManager.getBundleInfoForSelfSync(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    )
    //打开系统设置窗口，进行配置
    context.startAbility({
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: {
        pushParams: appInfo.name
      }
    })
  }
}

export let permissionManager = new PermissionManager()

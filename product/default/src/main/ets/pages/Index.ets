import { HMDefaultGlobalAnimator, HMNavigation } from "@hadss/hmrouter";
import { AttributeUpdater } from "@kit.ArkUI";
import { CommonConstants } from "basic";

@Entry
@Component
struct Index {
  modifier: MyNavModifier = new MyNavModifier();

  build() {
    // @Entry中需要再套一层容器组件,Column或者Stack
    Column(){
      // 使用HMNavigation容器
      HMNavigation({
        navigationId: CommonConstants.NAVIGATION_ID_PHONE, homePageUrl: 'LoginComp',
        options: {
          standardAnimator: HMDefaultGlobalAnimator.STANDARD_ANIMATOR,
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          modifier: this.modifier
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}

class MyNavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.hideNavBar(true);
  }
}
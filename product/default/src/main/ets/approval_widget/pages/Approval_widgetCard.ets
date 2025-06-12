let storageUpdateByMsg = new LocalStorage();
@Entry(storageUpdateByMsg)
@Component
struct Approval_widgetCard {
  @LocalStorageProp("wait") waitNum:number = 0
  @LocalStorageProp("complete") completeNum:number = 0
  @LocalStorageProp("reject") rejectNum:number = 0

  aboutToAppear(): void {

  }


  build() {
    Column({space:10}){
      Text(`待办：${this.waitNum}`)
      Text(`已完成：${this.completeNum}`)
      Text(`拒绝：${this.rejectNum}`)
    }
    .width("100%")
    .padding(20)
    .onClick(()=>{
      postCardAction(this,{
        action: 'call',
        bundleName: 'com.wsn.smartoffice',
        abilityName: 'EntryAbility',
        params: {
          message: 'testForRouter' // 自定义要发送的message
        }
      })
  })
  }
}
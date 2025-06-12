@Component
@CustomDialog
export struct SimpleLoading {
  //弹窗控制器
  controller: CustomDialogController

  //属性
  pWidth:number = 40       //默认大小
  maxNumber: number = 100  //最大值
  timer: number = -1       //定时循环器对象
  loadingText: string = '' //显示的文本

  //状态：进度值
  @State num: number = 0

  //生命周期
  aboutToAppear(): void {
    this.timer = setInterval(()=>{
      if(this.num === this.maxNumber){
        this.num = 0
      }
      this.num++
    }, 10)
  }
  aboutToDisappear(): void {
    //销毁：不能在后台运行
    clearInterval(this.timer)
  }

  //构建
  build() {
    Column({space:10}){
      Progress({
        value: this.num,
        total: this.maxNumber,
        type: ProgressType.ScaleRing
      })
        .width(this.pWidth)
        .style({strokeWidth: 2})
        .color($r('app.color.loading_simple_progress_background'))
      if(this.loadingText){
        Text(this.loadingText)
          .fontColor($r('app.color.loading_simple_progress_title_font'))
      }
    }
    .alignItems(HorizontalAlign.Center)
    .padding(this.loadingText ? 20 : 0 )
  }
}

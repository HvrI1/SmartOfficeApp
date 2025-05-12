@Component
export struct Message{

  build() {
    Column(){
      //搜索页面
      Search({placeholder:"搜索"})
        .width("90%")
        .height(30)
        .onSubmit((value:string)=>{
          //TODO:搜索回调
        })


    }
    .width("100%")
    .height("100%")
  }
}
export class BasicDataSource implements IDataSource {
  //实现：数据的总数
  totalCount(): number {
    return 0
  }

  //实现：按照索引获取指定元素
  getData(index: number): object | null {
    return null
  }

  //新增：监听功能列表
  listeners: DataChangeListener[] = []

  //实现：系统调用：注册数据改变时的监听能力
  //为LazyForEach组件，向它的数据源，添加Listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    //如果当前监听的数组中，不存在时，执行
    if(this.listeners.indexOf(listener) < 0){
      //添加
      this.listeners.push(listener)
      console.info('LazyForEach===>', '添加监听！')
    }
  }

  //实现：系统调用：移除数据改变时的监听能力
  unregisterDataChangeListener(listener: DataChangeListener): void {
    //获取索引
    const index = this.listeners.indexOf(listener)
    //如果监听数据数组中，存在的话
    if(index >= 0){
      //移除掉
      this.listeners.splice(index, 1)
      console.info('LazyForEach===>', '移除监听！')
    }
  }


  //新增：通知LazyForEach - 重新加载所有子组件
  notifyDataReload():void {
    this.listeners.forEach((listener)=>{
      listener.onDataReloaded()
    })
  }

  //新增：通知LazyForEach - 在对应索引的位置添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener)=>{
      //写法一：
      listener.onDataAdd(index)
      //写法二：
      //listener.onDatasetChange([{type:DataOperationType.ADD, index:index}])
    })
  }

  //新增：通知LazyForEach - 在对应索引的位置移除子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener)=>{
      //写法一：
      listener.onDataDelete(index)
      //写法二：
      //listener.onDatasetChange([{type:DataOperationType.DELETE, index:index}])
    })
  }

  //新增：通知LazyForEach - 在对应索引的数据改变时，重新创建子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach((listener)=>{
      //写法一：
      listener.onDataChange(index)
      //写法二：
      //listener.onDatasetChange([{type:DataOperationType.CHANGE, index:index}])
    })
  }

  //新增：通知LazyForEach - 将form和to两个对应索引位置的组件，进行交换
  notifyDataMove(from:number, to:number): void {
    this.listeners.forEach((listener)=>{
      //写法一：
      listener.onDataMove(from, to)
      //写法二：
      //listener.onDatasetChange([{type:DataOperationType.EXCHANGE, index:{start:from, end:to} }])
    })
  }

  //新增：通知LazyForEach - 当整个数据源改变时，整体更新
  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach((listener)=>{
      listener.onDatasetChange(operations)
    })
  }

}
export class ListDataSource extends BasicDataSource {
  //继承：第二大特性，得到父类中所有的，非私有的属性和行为
  //子类中，重写父类方法实现本质， 同时 追加数据类内容


  //私有属性：数据源
  private dataArray: object[] = []

  //重写实现：当前数据总数
  totalCount(): number {
    return this.dataArray.length
  }

  //重写实现：提取指定索引的对象
  getData(index: number): object | null {
    return this.dataArray[index]
  }

  //业务：向数据源中，添加数据
  pushData(data:object):void {
    //将传入的数据，加入数据源中
    this.dataArray.push(data)
    //调用方法，通知LazyForEach，有新元素了
    this.notifyDataAdd(this.dataArray.length-1)
  }

  //业务：重置数据源
  reloadData(list: object[]):void {
    //更新数据源
    this.dataArray = list
    //调用方法，通知LazyForEach，重置
    this.notifyDataReload()
  }
}
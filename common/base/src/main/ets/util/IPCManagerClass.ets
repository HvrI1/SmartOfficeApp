//【发布订阅模式】-提供功能类
import { commonEventManager } from "@kit.BasicServicesKit"

//枚举：通讯类型
//目的是统一应用中的
export enum PublishEventType {
  APP_PUBLISH = 'APP_PUBLISH',
  CARD_PUBLISH = 'CARD_PUBLISH'
}

//功能类
export class IPCManagerClass {

  //【发布者】
  static publicCount:number = 1
  static publish(eventType:PublishEventType, data:string){
    //调用系统方法，发布信息
    commonEventManager.publish(eventType, {data}, (err)=>{
      if(err){
        //发布失败，3次机会
        console.info('form===>', '发布失败:'+IPCManagerClass.publicCount)
        if(IPCManagerClass.publicCount < 3){
          //计数
          IPCManagerClass.publicCount++
          //递归，继续调用当前方法
          IPCManagerClass.publish(eventType, data)
        }
      }
      else{
        IPCManagerClass.publicCount = 1
        console.info('form===>', '发布成功！')
      }
    })
  }

  //【订阅者】
  static subscribe(
    eventType:PublishEventType,   //订阅类型
    subscribe?:commonEventManager.CommonEventSubscriber, //订阅到的对象
    callback?:(event:string)=>void //回调
  ){
    //调用系统方法，创建一个【订阅者】实例，要执行起来
    commonEventManager.createSubscriber({events:[eventType]}, (err, data)=>{
      if(err){
        //订阅异常
        console.info('form===>', JSON.stringify(err))
      }
      else{
        //提取订阅到的数据
        subscribe = data
        //判断
        if(subscribe !== undefined){
          //订阅处理
          commonEventManager.subscribe(subscribe, (err, data)=>{
            if(err){
              console.info('form===>', JSON.stringify(err))
            }
            else{
              //成功：调用外部传入的回调方法
              //将订阅到的结果，作为参数传入
              //这样就可以将结果，传入调用方法的位置了
              callback!(data.data!)
            }
          })
        }
        else{
          //没有订阅处理
          console.info('form===>', '需要创建订阅处理')
        }
      }
    })
  }
}


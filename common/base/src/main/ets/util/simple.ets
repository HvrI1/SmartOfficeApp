export function formatDate(dateParam:string|Date,isShowPrev:boolean,isShowAfter:boolean):string{
  let date = new Date(dateParam)
  let year= date.getFullYear()
  let month= date.getMonth()+1
  let day= date.getDate()
  let hour= date.getHours()
  let minter= date.getMinutes()
  let seconds= date.getSeconds()


  let monthStr = month<10?"0"+month:month.toString()
  let dayStr = day<10?"0"+day:day.toString()
  let hourStr = hour<10?"0"+hour:hour.toString()
  let minterStr = minter<10?"0"+minter:minter.toString()
  let secondsStr = seconds<10?"0"+seconds:seconds.toString()
  if(isShowPrev && isShowAfter){
    return `${year}-${monthStr}-${dayStr} ${hourStr}:${minterStr}:${secondsStr}`
  }else if (!isShowPrev && isShowAfter){
    return `${hourStr}:${minterStr}:${secondsStr}`
  }else if (isShowPrev && !isShowAfter){
    return `${year}-${monthStr}-${dayStr}`
  }else {
    return "入参错误"
  }
}
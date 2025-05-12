//用户类型接口和实例
export interface User{
  id?:number
  username:string;
  nick:string ;
  sex:string ;
  birthdate?:string;
  profilePhoto?:string;
  isVip?:string ;
  signature?:string;
  status?:string ; // 0-冻结 1-正常 2-注销
  email?:string;
  phone?:string;
  regionCode?:string;
  lastLoginIp?:string;
  lastLoginTime?:string;
  createTime?:string;
  updateTime?:string;
}
export class  UserModel implements User{
  id: number|undefined;
  username: string;
  nick: string;
  sex:string ;
  birthdate?: string | undefined;
  profilePhoto?: string | undefined;
  isVip?: string | undefined;
  signature?: string | undefined;
  status?: string | undefined;
  email?: string | undefined;
  phone?: string | undefined;
  regionCode?: string | undefined;
  lastLoginIp?: string | undefined;
  lastLoginTime?: string | undefined;
  createTime?: string | undefined;
  updateTime?: string | undefined;

  constructor(model:User) {
    this.id = model.id
    this.username = model.username;
    this.nick = model.nick;
    this.sex = model.sex;
    this.birthdate = model.birthdate;
    this.profilePhoto = model.profilePhoto;
    this.isVip = model.isVip;
    this.signature = model.signature;
    this.status = model.status;
    this.email = model.email;
    this.phone = model.phone;
    this.regionCode = model.regionCode;
    this.lastLoginIp = model.lastLoginIp;
    this.lastLoginTime = model.lastLoginTime;
    this.createTime = model.createTime;
    this.updateTime = model.updateTime;
  }


}

//用户登录DTO
export interface UserLoginDto{
  username?:string
  password?:string
  phone?:string
  verify?:string
}




import { RequestAxios, Result } from "basic"
import { User, UserLoginDto } from "../pojo"

//登录接口调用
export const loginApi = async (userLoginDto:UserLoginDto)=>{
    return RequestAxios.post<Result<string>>("/user/login",userLoginDto)
}

//根据用户名查询用户信息接口调用
export const queryUserInfoByUsernameApi = async (username:string)=>{
    return RequestAxios.get<Result<User>>(`/user/selectUserInfo?username=${username}`)
}
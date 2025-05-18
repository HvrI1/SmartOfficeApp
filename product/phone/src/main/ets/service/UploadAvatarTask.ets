import { CommonConstants, uploadFile } from "basic"
import Logger from "basic/src/main/ets/util/Logger"


@Concurrent
export async function UploadAvatarTask(params: Object[]) {
  try {
    const photoUrl = await uploadFile(params[0] as string, params[1] as Context);
    return photoUrl
  } catch (error) {
    Logger.error(CommonConstants.LOGGER_PREFIX, `上传失败:${error}`);
    return
  }
}
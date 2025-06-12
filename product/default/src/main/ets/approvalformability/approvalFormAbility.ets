import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError, commonEventManager, emitter } from '@kit.BasicServicesKit';
import { IPCManagerClass, PublishEventType } from 'base';

export default class approvalFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    const formData = '';
    console.log(JSON.stringify("onAddForm"))
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
    console.log(JSON.stringify("onCastToNormalForm"))
  }

  onUpdateForm(formId: string) {
    console.log(JSON.stringify("onUpdateForm"))

    // Called to notify the form provider to update a specified form.
  }

  onFormEvent(formId: string, message: string) {
    console.log(JSON.stringify("onFormEvent"))

    IPCManagerClass.publish(PublishEventType.CARD_PUBLISH,formId)


    // formProvider.setFormNextRefreshTime(formId,5,(error)=>{
    //   if (error) {
    //     console.error(`callback error, code: ${error.code}, message: ${error.message})`);
    //     return;
    //   }
    //   console.log(`formProvider setFormNextRefreshTime success`);
    // })
    //
    //
    //
    // let param: Record<string, number> = {
    //   'wait': 100,
    //   'complete': 200,
    //   'reject':50
    // }
    // let obj: formBindingData.FormBindingData = formBindingData.createFormBindingData(param);
    // formProvider.updateForm(formId, obj, (error: BusinessError) => {
    //   if (error) {
    //     console.error(`callback error, code: ${error.code}, message: ${error.message})`);
    //     return;
    //   }
    //   console.log(`formProvider updateForm success`);
    // });


    // Called when a specified message event defined by the form provider is triggered.
  }

  onRemoveForm(formId: string) {
     console.log(JSON.stringify("onRemoveForm"))
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
     console.log(JSON.stringify("onAcquireFormState"))
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}
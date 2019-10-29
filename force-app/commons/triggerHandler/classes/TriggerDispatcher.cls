/**
* MIT License
*
* Copyright (c) 2019 Piotr Kożuchowski
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/
public with sharing class TriggerDispatcher {

    /**
     * Runs trigger field defaults, validations and logic defined in custom metadata
     */
    public static void run() {
        run(new LogiclessTriggerHandler());
    }

    /**
     * Runs instance of concrete Trigger Handler implementation
     */
    public static void run(TriggerHandler triggerHandler) {
        run(triggerHandler, new TriggerContext());
    }

    @TestVisible
    private static void run(TriggerHandler triggerHandler, TriggerContext triggerContext) {
        if (triggerContext.isExecuting && !Bypass_Settings__c.getInstance().Bypass_Triggers__c) {
            SObjectFieldDefaults.apply(triggerContext.triggerRecords, triggerContext);
            SObjectValidator.validate(triggerContext.triggerRecords, triggerContext);
            SObjectTriggers.execute(triggerContext.triggerRecords, triggerContext);

            switch on triggerContext.operationType {
                when BEFORE_INSERT {
                    triggerHandler.onBeforeInsert(triggerContext.triggerNew, triggerContext);
                }
                when BEFORE_UPDATE {
                    triggerHandler.onBeforeUpdate(triggerContext.triggerNew, triggerContext);
                }
                when BEFORE_DELETE {
                    triggerHandler.onBeforeDelete(triggerContext.triggerOld, triggerContext);
                }
                when AFTER_INSERT {
                    triggerHandler.onAfterInsert(triggerContext.triggerNew, triggerContext);
                }
                when AFTER_UPDATE {
                    triggerHandler.onAfterUpdate(triggerContext.triggerNew, triggerContext);
                    triggerContext.cacheOldMap();
                }
                when AFTER_DELETE {
                    triggerHandler.onAfterDelete(triggerContext.triggerOld, triggerContext);
                }
                when AFTER_UNDELETE {
                    triggerHandler.onAfterUndelete(triggerContext.triggerNew, triggerContext);
                }
            }
        }
    }


    /**
     * Trigger handler without any logic.
     * Only logic defined in custom metadata is run.
     */
    private class LogiclessTriggerHandler implements TriggerHandler {
        public void onBeforeInsert(List<SObject> triggerNew, TriggerContext tc) {
        }
        public void onBeforeUpdate(List<SObject> triggerNew, TriggerContext tc) {
        }
        public void onBeforeDelete(List<SObject> triggerOld, TriggerContext tc) {
        }
        public void onAfterInsert(List<SObject> triggerNew, TriggerContext tc) {
        }
        public void onAfterUpdate(List<SObject> triggerNew, TriggerContext tc) {
        }
        public void onAfterDelete(List<SObject> triggerOld, TriggerContext tc) {
        }
        public void onAfterUndelete(List<SObject> triggerNew, TriggerContext tc) {
        }
    }
}
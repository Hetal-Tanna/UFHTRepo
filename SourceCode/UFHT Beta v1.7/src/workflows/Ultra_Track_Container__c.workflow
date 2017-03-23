<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification for Deployment Error</fullName>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <template>UFHT_Email_Templates/Notification_for_Deployment_Error</template>
    </alerts>
    <alerts>
        <fullName>Notification for Successful Deployment</fullName>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <template>UFHT_Email_Templates/Notification_for_Successful_Deployment</template>
    </alerts>
    <rules>
        <fullName>Send Notification for Deployment Error</fullName>
        <actions>
            <name>Notification for Deployment Error</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Ultra_Track_Container__c.Trigger_Status__c</field>
            <operation>equals</operation>
            <value>Not Deployed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification for Successful Deployment</fullName>
        <actions>
            <name>Notification for Successful Deployment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Ultra_Track_Container__c.Trigger_Status__c</field>
            <operation>equals</operation>
            <value>Deployed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

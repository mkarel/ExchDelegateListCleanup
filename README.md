# ExchDelegateListCleanup
This Powershell script will get a list of disabled AD accounts that has a value in the msExchDelegateListBL property. 
The Value in the Users msExchDelegateListBL property is that of the Mailbox that they had Full Access to.
The script will then recurse the depuplicated list of mailboxes and remove any disabled users.
The msExchDelegateListLink Property on the mailbox that was delegated will be updated with a new list of non disbaled delegates.

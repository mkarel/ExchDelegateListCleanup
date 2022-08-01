#Clean Disabled AD accounts of Delegates
#Get a list of disabled users who have a value in the AD property msExchDelegateListBL
$Users = get-aduser -Properties msExchDelegateListBL -Filter {enabled -eq "false"} | Where-Object {$_.msExchDelegateListBL -ne ""}
#Take the list of users and Create Variables with Unique lists of Mailboxes that have disbaled Delegates and a list of users
$Mailboxes = $users.msExchDelegateListBL | Select-Object -Unique
$DisabledUserDNs = $users.DistinguishedName | Select-Object -Unique
#Loop through the list of mailboxes checking the list of user to see if the mailbox has a disbaled user in it. 
Foreach($Mailbox in $Mailboxes){
    $DelegateList = (Get-ADUser -Identity $Mailbox -Properties msExchDelegateListLink).msExchDelegateListLink
    $msExchDelegateListLink = @{} 
    $msExchDelegateList = @()
    foreach($User in $DelegateList){
        if (!($DisabledUserDNs.contains($User))){
            #Build Array of Vaild Enabled Users
            $msExchDelegateList += $user
        }
    }
    #Build Hash Table of Vaild Enabled Users from the array $msExchDelegateList
     $msExchDelegateListLink.Add('msExchDelegateListLink',$msExchDelegateList)
     if ($msExchDelegateList.Count -eq 0){
        Set-ADUser -Identity $Mailbox -Clear msExchDelegateListLink
     }Else{
        Set-ADUser -Identity $Mailbox -Replace $msExchDelegateListLink
     }
}

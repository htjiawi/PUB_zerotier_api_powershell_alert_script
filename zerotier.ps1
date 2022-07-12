# tested on windows server 2019
# purpose automate console monitoring through Zerotier API token and send out SMTP alert on system offline over 1 hour
# script language: powershell
# VALUE YOU NEED TO UPDATE:
#    YOUR_NOTIFICATIO_EMAIL@DOMAIN.COM
#    AUTHORIZE_SENDER@DOMAIN.COM
#    YOUR_SMTP_OR_USE_MAIL.SMTOP2GO.COM
#    2525
#    YOUR_ZEROTIER_NETWORK
#    ZEROTIER_API_TOKEN
#    NODE_ID1 ..... NODE_IDx

clear
$global:hours = 0
$global:name = "x"
$global:node = "x"
$global:IP = "x"
$global:lines = ""
$global:issue = 0

function mailout
{
   $EmailTo = "YOUR_NOTIFICATIO_EMAIL@DOMAIN.COM"
   $EmailFrom = "AUTHORIZE_SENDER@DOMAIN.COM"
   $Subject = "Zerotier Alert"
   $Body = $global:lines
   $SMTPServer = "YOUR_SMTP_OR_USE_MAIL.SMTOP2GO.COM"
   $filenameAndPath = "C:\CDF.pdf"
   $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
   # $attachment = New-Object System.Net.Mail.Attachment($filenameAndPath)
   # $SMTPMessage.Attachments.Add($attachment)
   $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 2525)
   $SMTPClient.EnableSsl = $false
   #$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("SMTP_ID", "SMTP_PASSWORD_OR_KEY");
   $SMTPClient.Send($SMTPMessage)
}


function getzero ($node1)
{    
     $zerotier = Invoke-RestMethod https://my.zerotier.com/api/v1/network/YOUR_ZEROTIER_NETWORK/member/$node1 -Headers @{ Authorization = "Bearer ZEROTIER_API_TOKEN" }
     $record = $zerotier.lastOnline
     $datetime = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalMilliseconds
     $global:node = $node1
     $global:name = $zerotier.name
     $global:IP = $zerotier.physicalAddress
     $global:hours = ($datetime - $record)/3600000
     if ($global:hours -ge 1) {$global:issue = $global:issue + 1}
     write-Output "$global:node, $global:name, $global:IP, $global:hours"
     $global:lines = $global:lines + " " + $global:node + " " + $global:name + " " + $global:IP + " " + $global:hours + "`n"
}

getzero ("NODE_ID1")
getzero ("NODE_ID2")
getzero ("NODE_ID3")
getzero ("NODE_ID4")
getzero ("NODE_ID5")
getzero ("NODE_ID6")
getzero ("NODE_ID7")
getzero ("NODE_ID8")
getzero ("NODE_ID9")
getzero ("NODE_ID10")
getzero ("NODE_ID11")
getzero ("NODE_ID12")
getzero ("NODE_ID13")
getzero ("NODE_ID14")
getzero ("NODE_ID15")
getzero ("NODE_ID16")

# Write-Output $global:lines
if ($global:issue -gt 0) {mailout}

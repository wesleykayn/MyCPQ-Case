

## 1. Deploy the Changes

### From your project root (where sfdx-project.json is), <br>
sandbox: CPQ
``` cmd
sf project deploy start --source-dir force-app --target-org CPQ_SBX --wait 10
```
sandbox: Partialsb
```cmd
sf project deploy start --source-dir force-app --target-org partialsb --wait 10
```

<ul>
<li><code>--source-dir force-app</code> → deploys everything in that folder (all your edits).</li>
<li><code>--target-org CPQ_SBX</code> → the alias you created earlier.</li>
<li><code>--wait 10</code> → wait up to 10 minutes for deployment to complete.</li>
</ul>
<details>
  <summary>📌</summary>
<img width="1442" height="641" alt="image" src="https://github.com/user-attachments/assets/92742c0c-28b2-429f-b861-638cb81414eb" />
<tt>The following table reflects the changes.</tt>
</details>

### Or deploy just the file(s) you changed:<br>
``` cmd
sf project deploy start --source-dir force-app/main/unpackaged/anon-apex/activateContracts.apex --target-org CPQ_SBX --wait 10  
``` 

## Verify Deployment<br>
``` cmd
sf project deploy report --use-most-recent
``` 
## Test Changes<br>
``` cmd
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/activateContracts.apex -u CPQ_SBX
``` 
<tt>Note change the class/component name: ` activateContracts.apex` </tt>
________________________________________________________________________________________________________________

## 2. Verify Org Connection in CLI

Open your VS Code terminal and run:

```cmd
sf org list
```

or (legacy):
```cmd
sfdx force:org:list
```
<ul>
<li> If your sandbox alias (CPQ_SBX) appears in the list with a ✅, then VS Code (via Salesforce CLI) is connected to your sandbox.</li>
<li> You’ll see details like alias, username, org ID, instance URL, and expiration.</li>
</ul>

<details>
  <summary>📌</summary>
  <img width="1398" height="317" alt="image" src="https://github.com/user-attachments/assets/2b387d99-0019-4169-bb9d-27feb6fb8570" />
 
</details>



### Show Org Details

Run:
```cmd
sf org display --target-org CPQ_SBX
```

or:
```cmd
sfdx force:org:display -u CPQ_SBX

```
<details>
  <summary>📌</summary>
⚠️ Warning: This command will expose sensitive information that allows for subsequent activity using your current authenticated session.
Sharing this information is equivalent to logging someone in under the current credential, resulting in unintended access and escalation of privilege.
</details>

This will print sandbox details (username, instance URL, connected status). <br>
If it errors, then the connection isn’t set up correctly.


___________________________________________________________________________________________________________

GitHub: https://github.com/rjhalvorson/cancelAndReplace/blob/master/force-app/main/unpackaged/anon-apex/activateContracts.apex <br>
Steps: [CancelAndReplaceSteps.pdf](https://github.com/user-attachments/files/22176462/CancelAndReplaceSteps.pdf)
<br>
changes: D:\cancelAndReplace\cancelAndReplace\force-app\main\default\lwc\activeContracts <br>



___________________________________________________________________________________________________________

## 3. Deploy in the Root Repo

## A) cd into the real project root, then deploy
#### 1) Go to the folder that has sfdx-project.json
```cmd
cd /d/cancelAndReplace/cancelAndReplace 
```

#### 2) (optional) set default target org
``` cmd
sf config set target-org=CPQ_SBX
```
<details>
  <summary>📌</summary>
 <img width="798" height="287" alt="image" src="https://github.com/user-attachments/assets/bbceed4f-2946-4d3b-9964-99bc95943e1c" />
 
</details>



#### 3) Deploy just the LWC bundle (folder, not a single .js file)
``` cmd
sf project deploy start \
  --source-dir force-app/main/default/lwc/activeContracts \
  --target-org CPQ_SBX \
  --ignore-conflicts \
  --wait 10
```
<details>
  <summary>📌</summary>
  <img width="1397" height="787" alt="image" src="https://github.com/user-attachments/assets/0a5d6fb2-c530-482a-b2ab-0480e06afd20" />
 
</details>



 Tip: You can also deploy by metadata name:
``` cmd
sf project deploy start --metadata "LightningComponentBundle:activeContracts" --target-org CPQ_SBX --wait 10
```
## B) Stay in your current folder but point --project-dir to the root

#### From: /d/cancelAndReplace
``` cmd
sf project deploy start \
  --project-dir D:/cancelAndReplace/cancelAndReplace \
  --source-dir force-app/main/default/lwc/activeContracts \
  --target-org CPQ_SBX \
  --ignore-conflicts \
  --wait 10
```


________________________________________________________________________________________________

## Where i am?

#### Queueable Job ==> AsyncAmendAndZero <br>
Calls CPQ classes such as <code> ProductManager </code> and <code> QuoteCalculator </code> to load/zero out the existing subscription line items.
<ol>
  <li>A Master quote (the quote that created the contract) with a start date and subscription term.</li>
  <li>At least one subscription line <code>SBQQ_QuoteLine__c</code> tied to a pricebook product.</li>
</ol>


Without a quote, opportunity, pricebook or quote lines there is nothing for CPQ to “amend,” and ProductManager.load(contractId) will fail.

___________________________________________________________________________________________
step
PDF: [report_clean.pdf](https://github.com/user-attachments/files/22351008/report_clean.pdf)
Word Docs: [report_highlight.docx](https://github.com/user-attachments/files/22351275/report_highlight.docx)

___________________________________________________________________________________________

## Load demo data to try it quickly

The repo includes anonymous Apex seeders (if present in your clone) under:
```cmd
force-app/main/unpackaged/anon-apex/
  loadQuotes.apex
  placeOrders.apex
  activateOrders.apex
  contractQuotes.apex
  activateContracts.apex
```

Run them one by one and wait for each job to finish (Setup → Apex Jobs) before the next:
```cmd
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/loadQuotes.apex -u CPQ_ORG
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/placeOrders.apex -u CPQ_ORG
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/activateOrders.apex -u CPQ_ORG
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/contractQuotes.apex -u CPQ_ORG
sfdx force:apex:execute -f force-app/main/unpackaged/anon-apex/activateContracts.apex -u CPQ_ORG
```

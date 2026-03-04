---
title: "Prerequisites"
menuTitle: "Prerequisites"
weight: 20
---

Before attempting to create a stack with the templates, a few prerequisites should be checked to ensure a successful deployment:
1.  An AMI subscription must be active for the FortiGate license type being used in the template.
    * [**Intel BYOL Marketplace Listing**](https://aws.amazon.com/marketplace/pp/prodview-lvfwuztjwe5b2)
    * [**Intel PAYG Marketplace Listing**](https://aws.amazon.com/marketplace/pp/prodview-wory773oau6wq)
    * [**ARM BYOL Marketplace Listing**](https://aws.amazon.com/marketplace/pp/prodview-ccnrlwz74uwgk)
    * [**ARM PAYG Marketplace Listing**](https://aws.amazon.com/marketplace/pp/prodview-ohcnwr7nr2icy)

2.  The solution requires 3 EIPs to be created so ensure the AWS region being used has available capacity.  Reference [**AWS Documentation**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html) for more information on EC2 resource limits and how to request increases.

3.  If BYOL licensing is to be used, ensure these licenses have been registered on the support site.

4.  **Create a new S3 bucket in the same region where the template will be deployed.  If the bucket is in a different region than the template deployment, bootstrapping will fail and the FGTs will be inaccessible**.

5.  If BYOL licensing is to be used, upload these licenses to the root directory of the same S3 bucket from the step above.

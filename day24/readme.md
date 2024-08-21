# S3 Bucket Configuration and Static Website Hosting

This project demonstrates the creation, configuration, and management of an AWS S3 bucket for static website hosting. The project also covers the implementation of S3 storage classes, lifecycle management, bucket policies, and access control lists (ACLs).

## Project Steps and Deliverables

### 1. Create and Configure an S3 Bucket

1. **Bucket Creation:**
   - Created an S3 bucket named `techvista-portfolio-[your-initials]`.
   ![alt text](<Screenshot from 2024-08-13 15-21-48.png>)
   
2. **Versioning:**
   - Enabled versioning on the S3 bucket to maintain a history of object versions.
![alt text](<Screenshot from 2024-08-13 15-22-51.png>)
![alt text](<Screenshot from 2024-08-13 15-23-04.png>)
3. **Static Website Hosting:**
   - Configured the S3 bucket for static website hosting.
   - Uploaded the provided static website files (HTML, CSS, images).
   - Verified that the website is accessible via the S3 website URL.
![alt text](<Screenshot from 2024-08-13 15-56-06.png>)
### 2. Implement S3 Storage Classes

1. **Storage Classes:**
   - **HTML/CSS Files:** Stored in the **Standard** storage class to ensure fast access and low latency.
   - **Images:** Moved to **Intelligent-Tiering** storage class to automatically transition between frequent and infrequent access tiers based on usage.
   - **Older Versions of Objects:** Configured for **Glacier** storage class to minimize costs for long-term storage.
   ![alt text](<Screenshot from 2024-08-13 15-58-50.png>)

2. **Justification:**
   - **Standard:** Chosen for HTML/CSS files due to their frequent access.
   - **Intelligent-Tiering:** Chosen for images to balance cost and performance as access patterns change.
   - **Glacier:** Used for older versions of files that are infrequently accessed but need to be retained for archival purposes.

### 3. Lifecycle Management

1. **Lifecycle Policy Creation:**
   - Created a lifecycle policy that transitions older versions of objects to the **Glacier** storage class after 30 days.
   - Set up a policy to delete non-current versions of objects after 90 days to optimize storage costs.
   ![alt text](<Screenshot from 2024-08-13 16-00-41.png>)
![alt text](<Screenshot from 2024-08-13 16-00-43.png>)
2. **Verification:**
   - Verified the lifecycle policy by monitoring the storage transitions and confirming the correct application of the rules.

### 4. Configure Bucket Policies and ACLs

1. **Bucket Policies:**
   - Created and attached a bucket policy that allows public read access to everyone for the static website content.
   - Restricted access to the S3 management console for specific IAM users using a bucket policy to enforce security.
   ![alt text](<Screenshot from 2024-08-13 16-01-21.png>)
![alt text](<Screenshot from 2024-08-13 16-08-07.png>)
2. **ACL Setup:**
   - Configured an ACL to allow a specific external user access to only a particular folder within the bucket, ensuring fine-grained access control.

### 5. Test and Validate the Configuration

1. **Static Website Accessibility:**
   - Tested the static website URL to ensure the site is publicly accessible and loads correctly.

2. **Storage Class Transition Validation:**
   - Validated the lifecycle policy by checking that older object versions transitioned to the **Glacier** storage class as defined.

3. **Policy and ACL Testing:**
   - Simulated different access scenarios to verify the effectiveness of the bucket policies and ACLs.
   - Confirmed that unauthorized users were denied access and that the external user could access only the designated folder.

### 6. Documentation and Report

1. **Steps Performed:**
   - Documented each configuration step, including the reasoning behind the choices for storage classes, lifecycle policies, bucket policies, and ACLs.

2. **Screenshots:**
   - Included screenshots of the S3 bucket configuration, storage class transitions, lifecycle policies, and access controls.

3. **Project Summary:**
   - Summarized the project in a brief report, highlighting challenges such as setting up fine-grained access controls and validating lifecycle policies.
   - Documented how these challenges were addressed and resolved.

## Challenges and Resolutions

- **Challenge 1:** Properly configuring ACLs to allow access for specific external users while restricting others.
  - **Resolution:** Used a combination of bucket policies and ACLs to provide fine-grained access control.

- **Challenge 2:** Ensuring the correct application of lifecycle policies.
  - **Resolution:** Tested lifecycle transitions using test objects and verified the transitions in the S3 Management Console.

## Conclusion

This project successfully demonstrates how to configure an S3 bucket for static website hosting while implementing best practices for storage management, access control, and lifecycle management. The project highlights the importance of security and cost optimization when managing S3 buckets.
![alt text](<Screenshot from 2024-08-13 16-08-23.png>)
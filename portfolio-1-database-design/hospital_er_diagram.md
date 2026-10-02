# Hospital Database ER Diagram

This Entity-Relationship model supports patients, doctors, appointments, encounters, diagnoses, prescriptions, and laboratory records. Paste the Mermaid block into a Mermaid-enabled Markdown viewer, GitHub, or Mermaid Live Editor to render the diagram.

```mermaid
erDiagram
    USERS {
        BIGINT user_id PK
        VARCHAR username UK
        VARCHAR email UK
        ENUM role
        BOOLEAN is_active
    }
    DEPARTMENTS {
        INT department_id PK
        VARCHAR department_code UK
        VARCHAR department_name UK
        VARCHAR location
    }
    PATIENTS {
        BIGINT patient_id PK
        VARCHAR medical_record_number UK
        VARCHAR first_name
        VARCHAR last_name
        DATE date_of_birth
        ENUM sex
        VARCHAR phone
    }
    PATIENT_ADDRESSES {
        BIGINT address_id PK
        BIGINT patient_id FK
        ENUM address_type
        VARCHAR city
        VARCHAR state_province
        BOOLEAN is_primary
    }
    PATIENT_CONTACTS {
        BIGINT contact_id PK
        BIGINT patient_id FK
        VARCHAR contact_name
        VARCHAR relationship
        VARCHAR phone
    }
    DOCTORS {
        BIGINT doctor_id PK
        BIGINT user_id FK,UK
        INT department_id FK
        VARCHAR employee_number UK
        VARCHAR license_number UK
        VARCHAR first_name
        VARCHAR last_name
    }
    DOCTOR_SCHEDULES {
        BIGINT schedule_id PK
        BIGINT doctor_id FK
        TINYINT day_of_week
        TIME start_time
        TIME end_time
    }
    SPECIALIZATIONS {
        INT specialization_id PK
        VARCHAR specialization_name UK
    }
    DOCTOR_SPECIALIZATIONS {
        BIGINT doctor_id PK,FK
        INT specialization_id PK,FK
        BOOLEAN is_primary
    }
    APPOINTMENTS {
        BIGINT appointment_id PK
        VARCHAR appointment_number UK
        BIGINT patient_id FK
        BIGINT doctor_id FK
        BIGINT created_by FK
        DATETIME scheduled_start
        ENUM status
    }
    APPOINTMENT_STATUS_HISTORY {
        BIGINT history_id PK
        BIGINT appointment_id FK
        BIGINT changed_by FK
        ENUM old_status
        ENUM new_status
    }
    MEDICAL_RECORDS {
        BIGINT medical_record_id PK
        BIGINT patient_id FK
        BIGINT doctor_id FK
        BIGINT appointment_id FK,UK
        DATETIME encounter_date
        TEXT treatment_plan
    }
    DIAGNOSES {
        BIGINT diagnosis_id PK
        VARCHAR diagnosis_code UK
        VARCHAR diagnosis_name
    }
    MEDICAL_RECORD_DIAGNOSES {
        BIGINT medical_record_id PK,FK
        BIGINT diagnosis_id PK,FK
        ENUM diagnosis_type
    }
    MEDICATIONS {
        BIGINT medication_id PK
        VARCHAR generic_name
        VARCHAR brand_name
        VARCHAR strength
        VARCHAR dosage_form
    }
    PRESCRIPTIONS {
        BIGINT prescription_id PK
        VARCHAR prescription_number UK
        BIGINT patient_id FK
        BIGINT doctor_id FK
        BIGINT medical_record_id FK
        DATETIME prescribed_at
    }
    PRESCRIPTION_ITEMS {
        BIGINT prescription_item_id PK
        BIGINT prescription_id FK
        BIGINT medication_id FK
        VARCHAR dose
        VARCHAR frequency
        DECIMAL quantity
    }
    LAB_TESTS {
        INT lab_test_id PK
        VARCHAR test_code UK
        VARCHAR test_name UK
        VARCHAR specimen_type
    }
    LAB_ORDERS {
        BIGINT lab_order_id PK
        VARCHAR order_number UK
        BIGINT patient_id FK
        BIGINT ordering_doctor_id FK
        BIGINT medical_record_id FK
        ENUM status
    }
    LAB_ORDER_ITEMS {
        BIGINT lab_order_item_id PK
        BIGINT lab_order_id FK
        INT lab_test_id FK
        BIGINT collected_by FK
        ENUM status
    }
    LAB_RESULTS {
        BIGINT lab_result_id PK
        BIGINT lab_order_item_id FK,UK
        VARCHAR result_value
        ENUM abnormal_flag
        BIGINT verified_by FK
    }
    AUDIT_LOGS {
        BIGINT audit_id PK
        BIGINT user_id FK
        VARCHAR table_name
        VARCHAR record_id
        ENUM action_type
    }

    USERS o|--o| DOCTORS : "login identity"
    USERS o|--o{ APPOINTMENTS : creates
    USERS o|--o{ APPOINTMENT_STATUS_HISTORY : changes
    USERS o|--o{ LAB_ORDER_ITEMS : collects
    USERS o|--o{ LAB_RESULTS : verifies
    USERS o|--o{ AUDIT_LOGS : performs
    DEPARTMENTS ||--o{ DOCTORS : contains
    PATIENTS ||--o{ PATIENT_ADDRESSES : has
    PATIENTS ||--o{ PATIENT_CONTACTS : has
    DOCTORS ||--o{ DOCTOR_SCHEDULES : follows
    DOCTORS ||--o{ DOCTOR_SPECIALIZATIONS : has
    SPECIALIZATIONS ||--o{ DOCTOR_SPECIALIZATIONS : classifies
    PATIENTS ||--o{ APPOINTMENTS : books
    DOCTORS ||--o{ APPOINTMENTS : attends
    APPOINTMENTS ||--o{ APPOINTMENT_STATUS_HISTORY : tracks
    PATIENTS ||--o{ MEDICAL_RECORDS : owns
    DOCTORS ||--o{ MEDICAL_RECORDS : documents
    APPOINTMENTS o|--o| MEDICAL_RECORDS : produces
    MEDICAL_RECORDS ||--o{ MEDICAL_RECORD_DIAGNOSES : includes
    DIAGNOSES ||--o{ MEDICAL_RECORD_DIAGNOSES : identifies
    PATIENTS ||--o{ PRESCRIPTIONS : receives
    DOCTORS ||--o{ PRESCRIPTIONS : writes
    MEDICAL_RECORDS o|--o{ PRESCRIPTIONS : supports
    PRESCRIPTIONS ||--|{ PRESCRIPTION_ITEMS : contains
    MEDICATIONS ||--o{ PRESCRIPTION_ITEMS : selected
    PATIENTS ||--o{ LAB_ORDERS : receives
    DOCTORS ||--o{ LAB_ORDERS : orders
    MEDICAL_RECORDS o|--o{ LAB_ORDERS : requests
    LAB_ORDERS ||--|{ LAB_ORDER_ITEMS : contains
    LAB_TESTS ||--o{ LAB_ORDER_ITEMS : requested_as
    LAB_ORDER_ITEMS ||--o| LAB_RESULTS : produces
```

## Relationship Summary

- One patient can have many addresses, contacts, appointments, medical records, prescriptions, and laboratory orders.
- One doctor belongs to one department and may have many specializations through the junction table.
- An appointment may produce at most one medical record.
- A medical record can contain many diagnoses using a many-to-many junction table.
- A prescription contains one or more prescription items, each linked to a medication master record.
- A laboratory order contains one or more test items, with up to one verified result per item.

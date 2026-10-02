-- Hospital Management Database
-- Compatible with MySQL / MariaDB commonly bundled with XAMPP
-- Generated for phpMyAdmin import

CREATE DATABASE IF NOT EXISTS hospital_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hospital_management;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS lab_results;
DROP TABLE IF EXISTS lab_order_items;
DROP TABLE IF EXISTS lab_orders;
DROP TABLE IF EXISTS lab_tests;
DROP TABLE IF EXISTS prescription_items;
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS medical_record_diagnoses;
DROP TABLE IF EXISTS diagnoses;
DROP TABLE IF EXISTS medical_records;
DROP TABLE IF EXISTS appointment_status_history;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS doctor_specializations;
DROP TABLE IF EXISTS specializations;
DROP TABLE IF EXISTS doctor_schedules;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patient_contacts;
DROP TABLE IF EXISTS patient_addresses;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- Application users: administrators, doctors, laboratory staff, receptionists, etc.
CREATE TABLE users (
    user_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(120) NOT NULL,
    role ENUM('ADMIN','DOCTOR','NURSE','LAB_TECHNICIAN','PHARMACIST','RECEPTIONIST') NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    last_login_at DATETIME NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT uq_users_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE departments (
    department_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(20) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(150) NULL,
    phone_extension VARCHAR(10) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_departments_code UNIQUE (department_code),
    CONSTRAINT uq_departments_name UNIQUE (department_name)
) ENGINE=InnoDB;

CREATE TABLE patients (
    patient_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    medical_record_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(60) NOT NULL,
    middle_name VARCHAR(60) NULL,
    last_name VARCHAR(60) NOT NULL,
    date_of_birth DATE NOT NULL,
    sex ENUM('MALE','FEMALE','OTHER','UNKNOWN') NOT NULL,
    blood_group ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
    marital_status ENUM('SINGLE','MARRIED','DIVORCED','WIDOWED','OTHER') NULL,
    email VARCHAR(120) NULL,
    phone VARCHAR(30) NOT NULL,
    occupation VARCHAR(100) NULL,
    next_of_kin_name VARCHAR(150) NULL,
    next_of_kin_phone VARCHAR(30) NULL,
    allergies_summary TEXT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    registered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_patients_mrn UNIQUE (medical_record_number),
    INDEX idx_patients_name (last_name, first_name),
    INDEX idx_patients_phone (phone),
    INDEX idx_patients_dob (date_of_birth)
) ENGINE=InnoDB;

CREATE TABLE patient_addresses (
    address_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT UNSIGNED NOT NULL,
    address_type ENUM('HOME','WORK','OTHER') NOT NULL DEFAULT 'HOME',
    address_line1 VARCHAR(150) NOT NULL,
    address_line2 VARCHAR(150) NULL,
    city VARCHAR(80) NOT NULL,
    state_province VARCHAR(80) NOT NULL,
    postal_code VARCHAR(20) NULL,
    country VARCHAR(80) NOT NULL DEFAULT 'Nigeria',
    is_primary TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_patient_addresses_patient
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_patient_addresses_patient (patient_id)
) ENGINE=InnoDB;

CREATE TABLE patient_contacts (
    contact_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT UNSIGNED NOT NULL,
    contact_name VARCHAR(150) NOT NULL,
    relationship VARCHAR(60) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(120) NULL,
    is_emergency_contact TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_patient_contacts_patient
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_patient_contacts_patient (patient_id)
) ENGINE=InnoDB;

CREATE TABLE doctors (
    doctor_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NULL,
    department_id INT UNSIGNED NOT NULL,
    employee_number VARCHAR(30) NOT NULL,
    license_number VARCHAR(50) NOT NULL,
    first_name VARCHAR(60) NOT NULL,
    middle_name VARCHAR(60) NULL,
    last_name VARCHAR(60) NOT NULL,
    phone VARCHAR(30) NOT NULL,
    email VARCHAR(120) NOT NULL,
    hire_date DATE NULL,
    consultation_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_doctors_user UNIQUE (user_id),
    CONSTRAINT uq_doctors_employee UNIQUE (employee_number),
    CONSTRAINT uq_doctors_license UNIQUE (license_number),
    CONSTRAINT uq_doctors_email UNIQUE (email),
    CONSTRAINT fk_doctors_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_doctors_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_doctors_name (last_name, first_name),
    INDEX idx_doctors_department (department_id)
) ENGINE=InnoDB;

CREATE TABLE doctor_schedules (
    schedule_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    doctor_id BIGINT UNSIGNED NOT NULL,
    day_of_week TINYINT UNSIGNED NOT NULL COMMENT '1=Monday, 7=Sunday',
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(30) NULL,
    slot_duration_minutes SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    is_available TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT uq_doctor_schedule UNIQUE (doctor_id, day_of_week, start_time),
    CONSTRAINT fk_doctor_schedules_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_schedule_lookup (doctor_id, day_of_week, is_available)
) ENGINE=InnoDB;

CREATE TABLE specializations (
    specialization_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    specialization_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    CONSTRAINT uq_specializations_name UNIQUE (specialization_name)
) ENGINE=InnoDB;

CREATE TABLE doctor_specializations (
    doctor_id BIGINT UNSIGNED NOT NULL,
    specialization_id INT UNSIGNED NOT NULL,
    is_primary TINYINT(1) NOT NULL DEFAULT 0,
    certified_at DATE NULL,
    PRIMARY KEY (doctor_id, specialization_id),
    CONSTRAINT fk_ds_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ds_specialization FOREIGN KEY (specialization_id) REFERENCES specializations(specialization_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE appointments (
    appointment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    appointment_number VARCHAR(30) NOT NULL,
    patient_id BIGINT UNSIGNED NOT NULL,
    doctor_id BIGINT UNSIGNED NOT NULL,
    scheduled_start DATETIME NOT NULL,
    scheduled_end DATETIME NOT NULL,
    appointment_type ENUM('NEW_VISIT','FOLLOW_UP','EMERGENCY','TELEMEDICINE','PROCEDURE') NOT NULL,
    status ENUM('SCHEDULED','CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW') NOT NULL DEFAULT 'SCHEDULED',
    reason_for_visit VARCHAR(500) NOT NULL,
    notes TEXT NULL,
    created_by BIGINT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_appointments_number UNIQUE (appointment_number),
    CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_creator FOREIGN KEY (created_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_appointments_patient_date (patient_id, scheduled_start),
    INDEX idx_appointments_doctor_date (doctor_id, scheduled_start),
    INDEX idx_appointments_status_date (status, scheduled_start)
) ENGINE=InnoDB;

CREATE TABLE appointment_status_history (
    history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    appointment_id BIGINT UNSIGNED NOT NULL,
    old_status ENUM('SCHEDULED','CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW') NULL,
    new_status ENUM('SCHEDULED','CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW') NOT NULL,
    changed_by BIGINT UNSIGNED NULL,
    change_reason VARCHAR(255) NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ash_appointment FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ash_user FOREIGN KEY (changed_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_ash_appointment_date (appointment_id, changed_at)
) ENGINE=InnoDB;

CREATE TABLE medical_records (
    medical_record_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT UNSIGNED NOT NULL,
    doctor_id BIGINT UNSIGNED NOT NULL,
    appointment_id BIGINT UNSIGNED NULL,
    encounter_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    chief_complaint TEXT NULL,
    history_of_present_illness TEXT NULL,
    examination_notes TEXT NULL,
    temperature_c DECIMAL(4,1) NULL,
    blood_pressure_systolic SMALLINT UNSIGNED NULL,
    blood_pressure_diastolic SMALLINT UNSIGNED NULL,
    pulse_rate SMALLINT UNSIGNED NULL,
    respiratory_rate SMALLINT UNSIGNED NULL,
    weight_kg DECIMAL(6,2) NULL,
    height_cm DECIMAL(6,2) NULL,
    treatment_plan TEXT NULL,
    follow_up_date DATE NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uq_medical_records_appointment UNIQUE (appointment_id),
    CONSTRAINT fk_medical_records_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_medical_records_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_medical_records_appointment FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_medical_records_patient_date (patient_id, encounter_date),
    INDEX idx_medical_records_doctor (doctor_id)
) ENGINE=InnoDB;

CREATE TABLE diagnoses (
    diagnosis_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    diagnosis_code VARCHAR(20) NOT NULL COMMENT 'e.g., ICD-10 code',
    diagnosis_name VARCHAR(200) NOT NULL,
    description TEXT NULL,
    CONSTRAINT uq_diagnoses_code UNIQUE (diagnosis_code),
    INDEX idx_diagnoses_name (diagnosis_name)
) ENGINE=InnoDB;

CREATE TABLE medical_record_diagnoses (
    medical_record_id BIGINT UNSIGNED NOT NULL,
    diagnosis_id BIGINT UNSIGNED NOT NULL,
    diagnosis_type ENUM('PRIMARY','SECONDARY','DIFFERENTIAL') NOT NULL DEFAULT 'PRIMARY',
    notes VARCHAR(500) NULL,
    PRIMARY KEY (medical_record_id, diagnosis_id),
    CONSTRAINT fk_mrd_record FOREIGN KEY (medical_record_id) REFERENCES medical_records(medical_record_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_mrd_diagnosis FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(diagnosis_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE medications (
    medication_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    generic_name VARCHAR(150) NOT NULL,
    brand_name VARCHAR(150) NULL,
    strength VARCHAR(50) NULL,
    dosage_form VARCHAR(60) NOT NULL,
    manufacturer VARCHAR(150) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT uq_medication UNIQUE (generic_name, brand_name, strength, dosage_form),
    INDEX idx_medications_generic_name (generic_name)
) ENGINE=InnoDB;

CREATE TABLE prescriptions (
    prescription_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    prescription_number VARCHAR(30) NOT NULL,
    patient_id BIGINT UNSIGNED NOT NULL,
    doctor_id BIGINT UNSIGNED NOT NULL,
    medical_record_id BIGINT UNSIGNED NULL,
    prescribed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE','DISPENSED','PARTIALLY_DISPENSED','CANCELLED','EXPIRED') NOT NULL DEFAULT 'ACTIVE',
    notes TEXT NULL,
    CONSTRAINT uq_prescriptions_number UNIQUE (prescription_number),
    CONSTRAINT fk_prescriptions_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prescriptions_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_prescriptions_record FOREIGN KEY (medical_record_id) REFERENCES medical_records(medical_record_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_prescriptions_patient_date (patient_id, prescribed_at),
    INDEX idx_prescriptions_doctor (doctor_id)
) ENGINE=InnoDB;

CREATE TABLE prescription_items (
    prescription_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    prescription_id BIGINT UNSIGNED NOT NULL,
    medication_id BIGINT UNSIGNED NOT NULL,
    dose VARCHAR(50) NOT NULL,
    route VARCHAR(50) NOT NULL,
    frequency VARCHAR(80) NOT NULL,
    duration_days SMALLINT UNSIGNED NULL,
    quantity DECIMAL(10,2) NOT NULL,
    instructions VARCHAR(500) NULL,
    CONSTRAINT uq_prescription_medication UNIQUE (prescription_id, medication_id),
    CONSTRAINT fk_pi_prescription FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pi_medication FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_pi_medication (medication_id)
) ENGINE=InnoDB;

CREATE TABLE lab_tests (
    lab_test_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    test_code VARCHAR(30) NOT NULL,
    test_name VARCHAR(150) NOT NULL,
    specimen_type VARCHAR(80) NOT NULL,
    unit_of_measure VARCHAR(30) NULL,
    reference_range VARCHAR(100) NULL,
    price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    turnaround_hours SMALLINT UNSIGNED NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT uq_lab_tests_code UNIQUE (test_code),
    CONSTRAINT uq_lab_tests_name UNIQUE (test_name)
) ENGINE=InnoDB;

CREATE TABLE lab_orders (
    lab_order_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(30) NOT NULL,
    patient_id BIGINT UNSIGNED NOT NULL,
    ordering_doctor_id BIGINT UNSIGNED NOT NULL,
    medical_record_id BIGINT UNSIGNED NULL,
    ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    priority ENUM('ROUTINE','URGENT','STAT') NOT NULL DEFAULT 'ROUTINE',
    status ENUM('ORDERED','SPECIMEN_COLLECTED','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'ORDERED',
    clinical_notes TEXT NULL,
    CONSTRAINT uq_lab_orders_number UNIQUE (order_number),
    CONSTRAINT fk_lab_orders_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lab_orders_doctor FOREIGN KEY (ordering_doctor_id) REFERENCES doctors(doctor_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_lab_orders_record FOREIGN KEY (medical_record_id) REFERENCES medical_records(medical_record_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_lab_orders_patient_date (patient_id, ordered_at),
    INDEX idx_lab_orders_status (status, priority)
) ENGINE=InnoDB;

CREATE TABLE lab_order_items (
    lab_order_item_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    lab_order_id BIGINT UNSIGNED NOT NULL,
    lab_test_id INT UNSIGNED NOT NULL,
    status ENUM('ORDERED','SPECIMEN_COLLECTED','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'ORDERED',
    specimen_collected_at DATETIME NULL,
    collected_by BIGINT UNSIGNED NULL,
    CONSTRAINT uq_lab_order_test UNIQUE (lab_order_id, lab_test_id),
    CONSTRAINT fk_loi_order FOREIGN KEY (lab_order_id) REFERENCES lab_orders(lab_order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_loi_test FOREIGN KEY (lab_test_id) REFERENCES lab_tests(lab_test_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_loi_collector FOREIGN KEY (collected_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_loi_test (lab_test_id)
) ENGINE=InnoDB;

CREATE TABLE lab_results (
    lab_result_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    lab_order_item_id BIGINT UNSIGNED NOT NULL,
    result_value VARCHAR(255) NOT NULL,
    unit_of_measure VARCHAR(30) NULL,
    reference_range VARCHAR(100) NULL,
    abnormal_flag ENUM('NORMAL','LOW','HIGH','CRITICAL','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
    result_notes TEXT NULL,
    resulted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verified_by BIGINT UNSIGNED NULL,
    verified_at DATETIME NULL,
    CONSTRAINT uq_lab_results_order_item UNIQUE (lab_order_item_id),
    CONSTRAINT fk_lab_results_item FOREIGN KEY (lab_order_item_id) REFERENCES lab_order_items(lab_order_item_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_lab_results_verifier FOREIGN KEY (verified_by) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_lab_results_flag (abnormal_flag),
    INDEX idx_lab_results_date (resulted_at)
) ENGINE=InnoDB;

CREATE TABLE audit_logs (
    audit_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NULL,
    table_name VARCHAR(64) NOT NULL,
    record_id VARCHAR(64) NOT NULL,
    action_type ENUM('INSERT','UPDATE','DELETE','LOGIN','VIEW') NOT NULL,
    old_values LONGTEXT NULL COMMENT 'JSON text for compatibility across MySQL/MariaDB versions',
    new_values LONGTEXT NULL COMMENT 'JSON text for compatibility across MySQL/MariaDB versions',
    ip_address VARCHAR(45) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_audit_record (table_name, record_id),
    INDEX idx_audit_user_date (user_id, created_at)
) ENGINE=InnoDB;

-- Starter reference data
INSERT INTO departments (department_code, department_name, location) VALUES
('GEN', 'General Medicine', 'Main Building'),
('CARD', 'Cardiology', 'Specialist Wing'),
('PAED', 'Paediatrics', 'Children Wing'),
('LAB', 'Laboratory Services', 'Diagnostics Block');

INSERT INTO specializations (specialization_name) VALUES
('General Practice'), ('Cardiology'), ('Paediatrics'), ('Pathology');

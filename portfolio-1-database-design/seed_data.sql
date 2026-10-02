-- Synthetic seed data for hospital_management (MySQL/MariaDB XAMPP)
-- Run AFTER schema.sql. All names, contacts and clinical data are fictional.
USE hospital_management;
START TRANSACTION;

-- Existing schema.sql already creates departments 1-4 and specializations 1-4.
INSERT INTO departments (department_id,department_code,department_name,location,phone_extension) VALUES
(5,'ORTH','Orthopaedics','Specialist Wing','205'),(6,'RAD','Radiology','Diagnostics Block','306'),(7,'PHARM','Pharmacy','Main Building','117')
ON DUPLICATE KEY UPDATE location=VALUES(location),phone_extension=VALUES(phone_extension);
INSERT INTO specializations (specialization_id,specialization_name,description) VALUES
(5,'Internal Medicine','Adult medicine'),(6,'Orthopaedic Surgery','Musculoskeletal care'),(7,'Clinical Pathology','Laboratory diagnosis')
ON DUPLICATE KEY UPDATE description=VALUES(description);

INSERT INTO users (user_id,username,password_hash,email,role,is_active,last_login_at) VALUES
(1,'admin.demo','$2y$10$ReplaceWithRealHash','admin@hospital.test','ADMIN',1,'2026-10-01 08:00:00'),
(2,'doctor.amina','$2y$10$ReplaceWithRealHash','amina@hospital.test','DOCTOR',1,'2026-10-01 08:10:00'),
(3,'doctor.chinedu','$2y$10$ReplaceWithRealHash','chinedu@hospital.test','DOCTOR',1,'2026-10-01 08:15:00'),
(4,'doctor.bola','$2y$10$ReplaceWithRealHash','bola@hospital.test','DOCTOR',1,'2026-10-01 08:20:00'),
(5,'lab.kemi','$2y$10$ReplaceWithRealHash','kemi@hospital.test','LAB_TECHNICIAN',1,'2026-10-02 07:30:00'),
(6,'nurse.grace','$2y$10$ReplaceWithRealHash','grace@hospital.test','NURSE',1,'2026-10-02 07:20:00'),
(7,'pharm.tunde','$2y$10$ReplaceWithRealHash','tunde@hospital.test','PHARMACIST',1,NULL),
(8,'reception.ife','$2y$10$ReplaceWithRealHash','ife@hospital.test','RECEPTIONIST',1,'2026-10-02 06:50:00');

INSERT INTO patients (patient_id,medical_record_number,first_name,middle_name,last_name,date_of_birth,sex,blood_group,marital_status,email,phone,occupation,next_of_kin_name,next_of_kin_phone,allergies_summary,is_active,registered_at) VALUES
(1,'MRN-2026-0001','Adaeze','Ngozi','Eze','1988-04-12','FEMALE','O+','MARRIED','adaeze@example.test','+2348000001001','Accountant','Emeka Eze','+2348000001101','Penicillin',1,'2026-09-10 09:15:00'),
(2,'MRN-2026-0002','Musa',NULL,'Bello','1976-11-03','MALE','B+','MARRIED','musa@example.test','+2348000001002','Engineer','Zainab Bello','+2348000001102',NULL,1,'2026-09-11 10:20:00'),
(3,'MRN-2026-0003','Temilade','Ayo','Cole','1995-07-22','FEMALE','A+','SINGLE','temilade@example.test','+2348000001003','Designer','Femi Cole','+2348000001103','Peanuts',1,'2026-09-12 14:05:00'),
(4,'MRN-2026-0004','Ibrahim','Sani','Garba','2014-02-18','MALE','O-','SINGLE',NULL,'+2348000001004','Student','Maryam Garba','+2348000001104',NULL,1,'2026-09-15 08:45:00');
INSERT INTO patient_addresses (address_id,patient_id,address_type,address_line1,address_line2,city,state_province,postal_code,country,is_primary) VALUES
(1,1,'HOME','12 Sample Close','Ikeja','Lagos','Lagos','100271','Nigeria',1),(2,1,'WORK','8 Demo Avenue','Victoria Island','Lagos','Lagos','101241','Nigeria',0),(3,2,'HOME','44 Example Road',NULL,'Abuja','FCT','900211','Nigeria',1),(4,3,'HOME','7 Test Crescent','Yaba','Lagos','Lagos','101212','Nigeria',1),(5,4,'HOME','21 Sample Street',NULL,'Kano','Kano','700213','Nigeria',1);
INSERT INTO patient_contacts (contact_id,patient_id,contact_name,relationship,phone,email,is_emergency_contact) VALUES
(1,1,'Emeka Eze','Spouse','+2348000001101','emeka@example.test',1),(2,2,'Zainab Bello','Spouse','+2348000001102',NULL,1),(3,3,'Femi Cole','Brother','+2348000001103','femi@example.test',1),(4,4,'Maryam Garba','Mother','+2348000001104',NULL,1);

INSERT INTO doctors (doctor_id,user_id,department_id,employee_number,license_number,first_name,middle_name,last_name,phone,email,hire_date,consultation_fee,is_active) VALUES
(1,2,1,'EMP-DOC-001','MDCN-DEMO-1001','Amina',NULL,'Yusuf','+2348000002001','amina@hospital.test','2021-03-15',25000,1),
(2,3,2,'EMP-DOC-002','MDCN-DEMO-1002','Chinedu','Ike','Okafor','+2348000002002','chinedu@hospital.test','2019-08-01',40000,1),
(3,4,3,'EMP-DOC-003','MDCN-DEMO-1003','Bola','Funmi','Adebayo','+2348000002003','bola@hospital.test','2022-01-10',30000,1);
INSERT INTO doctor_schedules (schedule_id,doctor_id,day_of_week,start_time,end_time,room_number,slot_duration_minutes,is_available) VALUES
(1,1,1,'08:00','14:00','G101',30,1),(2,1,3,'08:00','14:00','G101',30,1),(3,2,2,'09:00','16:00','C201',45,1),(4,2,4,'09:00','16:00','C201',45,1),(5,3,1,'10:00','16:00','P301',30,1);
INSERT INTO doctor_specializations (doctor_id,specialization_id,is_primary,certified_at) VALUES
(1,1,1,'2020-05-18'),(1,5,0,'2023-06-12'),(2,2,1,'2018-09-25'),(3,3,1,'2021-08-20');

INSERT INTO appointments (appointment_id,appointment_number,patient_id,doctor_id,scheduled_start,scheduled_end,appointment_type,status,reason_for_visit,notes,created_by,created_at) VALUES
(1,'APT-2026-0001',1,1,'2026-09-21 09:00','2026-09-21 09:30','NEW_VISIT','COMPLETED','Persistent fever and fatigue','Arrived on time',8,'2026-09-18 12:00'),
(2,'APT-2026-0002',2,2,'2026-09-22 10:00','2026-09-22 10:45','FOLLOW_UP','COMPLETED','Blood pressure review',NULL,8,'2026-09-18 12:10'),
(3,'APT-2026-0003',4,3,'2026-09-23 11:00','2026-09-23 11:30','NEW_VISIT','COMPLETED','Cough and sore throat','Accompanied by parent',8,'2026-09-19 09:00'),
(4,'APT-2026-0004',3,1,'2026-10-05 10:00','2026-10-05 10:30','FOLLOW_UP','CONFIRMED','Review laboratory results',NULL,8,'2026-09-29 08:30');
INSERT INTO appointment_status_history (history_id,appointment_id,old_status,new_status,changed_by,change_reason,changed_at) VALUES
(1,1,NULL,'SCHEDULED',8,'Appointment created','2026-09-18 12:00'),(2,1,'SCHEDULED','CHECKED_IN',8,'Patient arrived','2026-09-21 08:55'),(3,1,'CHECKED_IN','COMPLETED',2,'Consultation completed','2026-09-21 09:28'),(4,2,'SCHEDULED','COMPLETED',3,'Review completed','2026-09-22 10:42'),(5,3,'SCHEDULED','COMPLETED',4,'Consultation completed','2026-09-23 11:27'),(6,4,'SCHEDULED','CONFIRMED',8,'Confirmed by patient','2026-10-01 10:00');

INSERT INTO medical_records (medical_record_id,patient_id,doctor_id,appointment_id,encounter_date,chief_complaint,history_of_present_illness,examination_notes,temperature_c,blood_pressure_systolic,blood_pressure_diastolic,pulse_rate,respiratory_rate,weight_kg,height_cm,treatment_plan,follow_up_date) VALUES
(1,1,1,1,'2026-09-21 09:05','Fever and fatigue','Three-day history','Mild dehydration',38.2,118,76,92,18,68.4,165,'Hydration, antipyretic and tests','2026-10-05'),
(2,2,2,2,'2026-09-22 10:05','Hypertension follow-up','Readings remain elevated','Stable examination',36.7,148,94,78,17,84.2,176,'Continue medicine and review','2026-10-20'),
(3,4,3,3,'2026-09-23 11:05','Cough and sore throat','Symptoms for two days','Mild pharyngeal erythema',37.6,105,68,88,20,42.5,151,'Supportive care','2026-09-30');
INSERT INTO diagnoses (diagnosis_id,diagnosis_code,diagnosis_name,description) VALUES
(1,'R50.9','Fever, unspecified','Unspecified fever'),(2,'I10','Essential hypertension','Primary hypertension'),(3,'J02.9','Acute pharyngitis, unspecified','Acute pharyngeal inflammation'),(4,'E86.0','Dehydration','Fluid depletion');
INSERT INTO medical_record_diagnoses (medical_record_id,diagnosis_id,diagnosis_type,notes) VALUES
(1,1,'PRIMARY','Clinical fever'),(1,4,'SECONDARY','Mild dehydration'),(2,2,'PRIMARY','Above target'),(3,3,'PRIMARY','Likely uncomplicated');

INSERT INTO medications (medication_id,generic_name,brand_name,strength,dosage_form,manufacturer,is_active) VALUES
(1,'Paracetamol','DemoPar','500 mg','Tablet','Demo Pharma',1),(2,'Amlodipine','DemoAmlod','5 mg','Tablet','Demo Pharma',1),(3,'Oral Rehydration Salts','DemoORS','20.5 g','Powder for solution','Sample Health',1),(4,'Saline Gargle',NULL,'0.9%','Solution','Training Supplies',1);
INSERT INTO prescriptions (prescription_id,prescription_number,patient_id,doctor_id,medical_record_id,prescribed_at,status,notes) VALUES
(1,'RX-2026-0001',1,1,1,'2026-09-21 09:25','DISPENSED','Demo only'),(2,'RX-2026-0002',2,2,2,'2026-09-22 10:35','ACTIVE','Monitor blood pressure'),(3,'RX-2026-0003',4,3,3,'2026-09-23 11:22','DISPENSED','Guardian counselled');
INSERT INTO prescription_items (prescription_item_id,prescription_id,medication_id,dose,route,frequency,duration_days,quantity,instructions) VALUES
(1,1,1,'500 mg','Oral','Every 8 hours as needed',3,9,'Take after food'),(2,1,3,'1 sachet','Oral','As directed',2,4,'Dissolve in clean water'),(3,2,2,'5 mg','Oral','Once daily',30,30,'Take at same time daily'),(4,3,1,'250 mg','Oral','Every 8 hours as needed',3,9,'Use clinician-directed dose'),(5,3,4,'15 mL','Oropharyngeal','Three times daily',5,1,'Gargle and spit out');

INSERT INTO lab_tests (lab_test_id,test_code,test_name,specimen_type,unit_of_measure,reference_range,price,turnaround_hours,is_active) VALUES
(1,'FBC','Full Blood Count','Whole blood',NULL,'Component-specific',7500,4,1),(2,'MAL-RDT','Malaria Rapid Diagnostic Test','Whole blood',NULL,'Negative',4000,1,1),(3,'FPG','Fasting Plasma Glucose','Plasma','mg/dL','70-99',3500,3,1),(4,'LIPID','Lipid Profile','Serum',NULL,'Component-specific',12000,6,1);
INSERT INTO lab_orders (lab_order_id,order_number,patient_id,ordering_doctor_id,medical_record_id,ordered_at,priority,status,clinical_notes) VALUES
(1,'LAB-2026-0001',1,1,1,'2026-09-21 09:20','URGENT','COMPLETED','Investigate fever'),(2,'LAB-2026-0002',2,2,2,'2026-09-22 10:30','ROUTINE','COMPLETED','Risk review');
INSERT INTO lab_order_items (lab_order_item_id,lab_order_id,lab_test_id,status,specimen_collected_at,collected_by) VALUES
(1,1,1,'COMPLETED','2026-09-21 09:40',5),(2,1,2,'COMPLETED','2026-09-21 09:42',5),(3,2,3,'COMPLETED','2026-09-22 10:50',5),(4,2,4,'COMPLETED','2026-09-22 10:50',5);
INSERT INTO lab_results (lab_result_id,lab_order_item_id,result_value,unit_of_measure,reference_range,abnormal_flag,result_notes,resulted_at,verified_by,verified_at) VALUES
(1,1,'Haemoglobin 12.4; WBC 8.6; Platelets 245',NULL,'Component-specific','NORMAL','Demo result','2026-09-21 12:15',5,'2026-09-21 12:25'),(2,2,'Negative',NULL,'Negative','NORMAL','No antigen detected','2026-09-21 10:15',5,'2026-09-21 10:20'),(3,3,'106','mg/dL','70-99','HIGH','Correlate clinically','2026-09-22 13:00',5,'2026-09-22 13:10'),(4,4,'Total 205; LDL 132; HDL 46',NULL,'Component-specific','HIGH','Demo result','2026-09-22 15:30',5,'2026-09-22 15:45');

INSERT INTO audit_logs (audit_id,user_id,table_name,record_id,action_type,old_values,new_values,ip_address,created_at) VALUES
(1,8,'appointments','1','INSERT',NULL,'{"status":"SCHEDULED"}','127.0.0.1','2026-09-18 12:00'),(2,2,'medical_records','1','INSERT',NULL,'{"patient_id":1}','127.0.0.1','2026-09-21 09:25'),(3,5,'lab_results','1','INSERT',NULL,'{"abnormal_flag":"NORMAL"}','127.0.0.1','2026-09-21 12:15');
COMMIT;

-- Verification summary
SELECT 'patients' table_name,COUNT(*) row_count FROM patients
UNION ALL SELECT 'doctors',COUNT(*) FROM doctors
UNION ALL SELECT 'appointments',COUNT(*) FROM appointments
UNION ALL SELECT 'prescriptions',COUNT(*) FROM prescriptions
UNION ALL SELECT 'lab_results',COUNT(*) FROM lab_results;

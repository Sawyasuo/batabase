----Transaction ที่ 1: กระบวนการสมัครสมาชิกผู้ปกครองพร้อมลงทะเบียนลูก (Register Parent & Student)
DECLARE
    v_user_id   Users.user_id%TYPE;
    v_parent_id Parents.parent_id%TYPE;
BEGIN
    
    INSERT INTO Users (username, password_hash, email, phone, role)
    VALUES ('parent_somchai', '$2a$12$eImig...', 'somchai@email.com', '0812345678', 'PARENT')
    RETURNING user_id INTO v_user_id;

   
    INSERT INTO Parents (user_id, full_name)
    VALUES (v_user_id, 'นายสมชาย ใจดี')
    RETURNING parent_id INTO v_parent_id;

    
    INSERT INTO Students (student_code, student_name, parent_id, class_id)
    VALUES ('STD-2026-001', 'ด.ช.สมปอง ใจดี', v_parent_id, 1);

      COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        
        ROLLBACK;
        RAISE;
END;
/

---Transaction ที่ 2: กระบวนการส่งการบ้านและอัปเดตสถานะ (Submit Homework)
BEGIN
    
    INSERT INTO HomeworkSubmission (
        homework_id, 
        student_id, 
        submiss_file, 
        submiss_status, 
        submitted_at
    ) VALUES (
        5, 
        12, 
        '/uploads/homework/hw_5_std_12.pdf', 
        'SUBMITTED', 
        SYSTIMESTAMP
    );

    
    UPDATE Homework
    SET updated_at = SYSTIMESTAMP
    WHERE homework_id = 5 
      AND deleted_at IS NULL;

   
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
       
        ROLLBACK;
        RAISE;
END;
/
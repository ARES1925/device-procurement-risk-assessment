function procurement_risk_analysis()
    % ---------------------------------------------------------
    % PROBABILISTIC RISK ASSESSMENT for $20M DEVICE PROCUREMENT
    % Calculates joint, marginal, and conditional probabilities 
    % to validate vendor testing reliability.
    % ---------------------------------------------------------
    
    fprintf('--- $20M Procurement Risk Assessment ---\n\n');

    % Let A = Device is NOT defective
    % Let B = Test says device IS defective
    % Therefore:
    % A_c (A complement) = Device IS defective
    % B_c (B complement) = Test says device is NOT defective

    % --- GIVEN VENDOR DATA (Conditional Probabilities) ---
    % 1. 90% of devices are not defective when tests say they are not.
    P_A_given_Bc = 0.90; 
    
    % 2. 5% of devices are not defective when tests say they are.
    P_A_given_B = 0.05;  
    
    % 3. 95% of devices are defective when tests say they are.
    % (Assuming normalization where P(A|B) + P(A_c|B) = 1)
    P_Ac_given_B = 1 - P_A_given_B; 
    
    % 4. 10% of devices are defective when tests say they are not.
    P_Ac_given_Bc = 1 - P_A_given_Bc; 

    % Assume an arbitrary baseline positive test rate P(B) based on 20-year historical average 
    % (Adjustable parameter to test different vendor batches)
    P_B = 0.12; 
    P_Bc = 1 - P_B;

    % --- PART 1: JOINT PROBABILITIES (Intersections) ---
    % P(X ∩ Y) = P(X|Y) * P(Y)
    P_A_and_B   = P_A_given_B * P_B;
    P_A_and_Bc  = P_A_given_Bc * P_Bc;
    P_Ac_and_B  = P_Ac_given_B * P_B;
    P_Ac_and_Bc = P_Ac_given_Bc * P_Bc;

    % --- PART 3: MARGINAL PROBABILITIES ---
    % P(X) = P(X ∩ Y) + P(X ∩ Y_c)
    P_A  = P_A_and_B + P_A_and_Bc;
    P_Ac = P_Ac_and_B + P_Ac_and_Bc;

    % --- PART 4: REVERSED CONDITIONAL PROBABILITIES (Bayes' Theorem) ---
    % P(Y|X) = P(X ∩ Y) / P(X)
    P_B_given_A   = P_A_and_B / P_A;
    P_B_given_Ac  = P_Ac_and_B / P_Ac;
    P_Bc_given_A  = P_A_and_Bc / P_A;
    P_Bc_given_Ac = P_Ac_and_Bc / P_Ac;

    % --- EXECUTIVE DECISION LOGIC ---
    fprintf('--- Vendor Testing Reliability Metrics ---\n');
    fprintf('True Defective Rate P(A^c): %.2f%%\n', P_Ac * 100);
    fprintf('False Positive Rate P(B|A): %.2f%%\n', P_B_given_A * 100);
    fprintf('False Negative Rate P(B^c|A^c): %.2f%%\n\n', P_Bc_given_Ac * 100);
    
    % Risk Thresholds for $20M Investment
    max_acceptable_defect_rate = 0.15; % 15% Max tolerance
    max_false_negative_rate = 0.05;    % 5% Max tolerance for missed defects
    
    fprintf('--- FINAL RECOMMENDATION ---\n');
    if (P_Ac > max_acceptable_defect_rate) || (P_Bc_given_Ac > max_false_negative_rate)
        fprintf('NO-GO: The vendor data indicates unacceptable risk levels.\n');
        fprintf('The $20M capital investment is NOT recommended.\n');
    else
        fprintf('GO: The vendor testing metrics fall within acceptable bounds.\n');
        fprintf('The $20M capital investment is RECOMMENDED.\n');
    end
end

# **Repository Description**

Welcome to the **GPU-Powered Password Cracker** project! This tool is designed to demonstrate how quickly and efficiently a computer can guess a secret password by trying every possible combination of letters and numbers. Whether you're curious about password security or interested in understanding the power of modern graphics cards, this project offers an insightful look into the world of password cracking.

### **What It Does**

At its core, this project attempts to uncover a hidden password by systematically trying every possible combination of characters until it finds a match. Imagine trying to guess a friend's password by trying every possible mix of letters and numbers until you get it right—that's exactly what this tool does, but with the speed and precision of a powerful computer.

### **How It Works**

The tool leverages the immense processing power of your computer's graphics card (GPU) to perform these guesses at lightning-fast speeds. By breaking down the task into millions or even billions of attempts per second, the tool can rapidly narrow down the possibilities and identify the correct password in a fraction of the time it would take using a standard processor.

### **Performance Highlights**

- **Python Version:** Utilizing the capabilities of a **4070 Ti Super** GPU, the Python-based version of this tool can perform up to **20,000,000 trials per second**. This means it can try twenty million different password combinations every second, significantly speeding up the guessing process.

- **C++ Version:** For those who prefer a more optimized approach, the C++ version takes advantage of the same **4070 Ti Super** GPU to achieve an astonishing **15,000,000,000 trials per second**. That's fifteen billion attempts every second, showcasing the incredible efficiency and speed possible with the right programming language and hardware.

### **Testing**

If you want to test the Python code, simply import the necessary libraries and run the script. However, if you want to work with the C++ code, follow these steps:  
1. Open the Command Prompt (or terminal).  
2. Navigate to the folder containing the C++ code.  
3. Compile the code using the command:  
   ```bash
   nvcc -o output_name input_name
   ```  
Here, replace `output_name` with the desired name for the compiled executable and `input_name` with the name of your C++ source file (e.g., `myfile.cu`).

### **Educational Purpose**

The primary goal of this project is educational. It serves as a powerful demonstration of how quickly passwords can be compromised using advanced technology. By visualizing the cracking process, users can better understand the importance of creating strong, complex passwords to safeguard their digital information.

### **Why Use This Tool?**

- **Learn About Password Security:** Gain insights into how easily simple passwords can be cracked, emphasizing the need for robust password practices.
- **Explore GPU Capabilities:** Discover the incredible processing power of modern GPUs and how they can be harnessed for tasks beyond gaming and graphics.
- **Hands-On Experience:** Engage with a practical application of technology that showcases both programming and cybersecurity principles.

### **Getting Started**

Using the GPU-Powered Password Cracker is straightforward:

1. **Enter the Password:** Input the password you want the tool to attempt to guess.
2. **Start Cracking:** Click the "Start" button to begin the cracking process.
3. **Monitor Progress:** Watch as the tool tries different combinations, displaying real-time updates on its progress.
4. **View Results:** Once the password is found or all combinations are exhausted, the tool will display the outcome along with the total number of attempts made.

### **Ethical Considerations**

While this tool showcases the impressive capabilities of modern technology, it's essential to use it responsibly. Password cracking should only be performed on passwords you have permission to test, such as your own, to ensure ethical use and respect for privacy and security.

---

**Disclaimer:** This tool is intended for educational purposes only. Unauthorized use of password cracking tools is illegal and unethical. Always ensure you have explicit permission before attempting to crack any password.

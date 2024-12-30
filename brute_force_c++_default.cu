#include <iostream>
#include <string>
#include <chrono>
#include <cuda_runtime.h>

using namespace std;

__global__ void bruteForceKernel(const char* characters, int charactersLength, const char* password, int passwordLength, bool* found, char* result, long long startAttempt, long long endAttempt, unsigned long long* attemptCount) {
    long long index = startAttempt + blockIdx.x * blockDim.x + threadIdx.x;
    if (index >= endAttempt) return;

    char guess[32]; // Maksimum şifre uzunluğu
    long long temp = index;

    // Kombinasyon oluştur
    for (int i = 0; i < passwordLength; i++) {
        guess[i] = characters[temp % charactersLength];
        temp /= charactersLength;
    }
    guess[passwordLength] = '\0';

    // Şifre eşleşmesini kontrol et
    bool match = true;
    for (int i = 0; i < passwordLength; i++) {
        if (guess[i] != password[i]) {
            match = false;
            break;
        }
    }

    // Eşleşme bulunduysa sonucu kaydet
    if (match) {
        *found = true;
        for (int i = 0; i < passwordLength; i++) {
            result[i] = guess[i];
        }
        result[passwordLength] = '\0';
    }

    // Deneme sayısını artır
    atomicAdd(attemptCount, 1);
}

string bruteForce(const string& password, unsigned long long& totalAttempts) {
    const string characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const int charactersLength = characters.length();
    const int passwordLength = password.length();

    totalAttempts = 1;
    for (int i = 0; i < passwordLength; i++) {
        totalAttempts *= charactersLength;
    }

    bool* dev_found;
    char* dev_result;
    char* dev_characters;
    char* dev_password;
    unsigned long long* dev_attemptCount;

    // Bellek ayırma
    cudaMalloc((void**)&dev_found, sizeof(bool));
    cudaMalloc((void**)&dev_result, (passwordLength + 1) * sizeof(char));
    cudaMalloc((void**)&dev_characters, charactersLength * sizeof(char));
    cudaMalloc((void**)&dev_password, passwordLength * sizeof(char));
    cudaMalloc((void**)&dev_attemptCount, sizeof(unsigned long long));

    // Veriyi kopyalama
    cudaMemcpy(dev_characters, characters.c_str(), charactersLength * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_password, password.c_str(), passwordLength * sizeof(char), cudaMemcpyHostToDevice);

    bool found = false;
    cudaMemcpy(dev_found, &found, sizeof(bool), cudaMemcpyHostToDevice);

    unsigned long long attemptCount = 0;
    cudaMemcpy(dev_attemptCount, &attemptCount, sizeof(unsigned long long), cudaMemcpyHostToDevice);

    // CUDA çekirdeğini çağırma
    int blockSize = 256;
    long long attemptsPerKernel = 1000000; // Her kernel çağrısında 1 milyon deneme
    for (long long startAttempt = 0; startAttempt < totalAttempts; startAttempt += attemptsPerKernel) {
        long long endAttempt = min(startAttempt + attemptsPerKernel, totalAttempts);
        long long numBlocks = (endAttempt - startAttempt + blockSize - 1) / blockSize;
        bruteForceKernel<<<numBlocks, blockSize>>>(dev_characters, charactersLength, dev_password, passwordLength, dev_found, dev_result, startAttempt, endAttempt, dev_attemptCount);
        cudaMemcpy(&found, dev_found, sizeof(bool), cudaMemcpyDeviceToHost);
        if (found) break;
    }

    // Sonucu geri kopyalama
    char result[32];
    cudaMemcpy(result, dev_result, (passwordLength + 1) * sizeof(char), cudaMemcpyDeviceToHost);
    cudaMemcpy(&attemptCount, dev_attemptCount, sizeof(unsigned long long), cudaMemcpyDeviceToHost);

    // Belleği serbest bırakma
    cudaFree(dev_found);
    cudaFree(dev_result);
    cudaFree(dev_characters);
    cudaFree(dev_password);
    cudaFree(dev_attemptCount);

    if (found) {
        cout << "Password found: " << result << endl;
        cout << "Total attempts: " << attemptCount << endl;
        return result;
    } else {
        cout << "Password not found." << endl;
        cout << "Total attempts: " << attemptCount << endl;
        return "";
    }
}

int main() {
    string password;
    cout << "Please enter a password: ";
    cin >> password;

    auto start = chrono::high_resolution_clock::now();
    unsigned long long totalAttempts;
    bruteForce(password, totalAttempts);
    auto end = chrono::high_resolution_clock::now();

    chrono::duration<double> elapsed = end - start;
    cout << "Elapsed time: " << elapsed.count() << " seconds" << endl;

    // Prevent the console from closing immediately
    cout << "Press any key to exit...";
    cin.ignore(); // Clear the previous input
    cin.get();    // Wait for the user to press a key

    return 0;
}
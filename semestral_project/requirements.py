import subprocess

# List of required packages with specific versions
required_packages = [
    'appopener==1.7',
    'customtkinter==5.2.0',
    'regex==2023.8.8',
    # Add more package names and versions here
]

# Install the packages
for package in required_packages:
    subprocess.check_call(['pip', 'install', package])

print("All required packages have been successfully installed.")

# Step to use vagrant files

## 1- Choose the tool you want to start and go to the corresponding folder
example : cd vagrant/jenkins

## 2- Install vagrant and virtualbox
Please refer to the official documentation based on your host OS and CPU

[Vagrant](https://www.vagrantup.com/docs/installation)

[Virtuabox](https://www.virtualbox.org/wiki/Downloads)

## 3- Install vagrant plugin
```
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-faster
vagrant plugin install vagrant-cachier

Si message d'erreur
vagrant plugin install --plugin-clean-sources --plugin-source https://rubygems.org vagrant-faster
vagrant plugin install --plugin-clean-sources --plugin-source https://rubygems.org vagrant-cachier
```

## 4- Run your desire stack
```
vagrant up
```

## 5- Connect to the deployed VM
```
vagrant ssh <stack name>
```

## 6- Delete the stack
```
vagrant destroy
```

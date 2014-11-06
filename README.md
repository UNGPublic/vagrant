vagrant
=======

Vagrantfile para VM com ambiente para desenvolvimento do sample com AngularJS.  

## O que tem na VM ##
- apache httpd  
- openjdk 7
- tomcat 8
- mongodb (ultima versão do repo)

## Instruções de instalação  
- Instale o VirtualBox
- Instale o Vagrant
- Instale o git
- Crie um diretório em seu pc e o acesse via command/terminal
- Clone este projeto
- Acesse o diretório vagrant e digite vagrant up
 
Após subir a VM, você pode realizar o deploy dos projeto a partir de sua IDE.  
Veja a documentação de cada projeto para verificar como realizar o deploy.  
A VM fica acessível também via SSH (use o putty, por exemplo).  

## Port forwarding  
Da máquina local é possível acessar os serviços na VM. O mapeamento das portas fica assim:  
80 na vm -> 18000 no host   
8080 na vm -> 18080 no host  
27017 na vm -> 27017 no host  

_Se estes valores conflitarem com as configuracoes de sua maquina, voce pode altera-los no arquivo Vagrantfile_

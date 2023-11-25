#!/bin/bash


clear
echo 'Selcione uma opcao'
echo ''
echo '[1] - Criar novo usuario'
echo '[2] - Mostrar informacoes'
echo '[3] - Grupos do usuario'

echo '[9] - Deletar usuario'
echo ''
echo '[0] - Sair'
echo -n 'digite: '
read numero


case $numero in
	#criar usuario
	"1")
		sudo groupadd admGroup
		sudo groupadd empregadoGroup
		sudo groupadd estagiarioGroup

		sudo groupadd audio
		sudo groupadd video
		sudo groupadd storage
		sudo groupadd scanner
		sudo groupadd users

		mkdir /etc/temp_skel


		clear
		echo '---------------------------------------------'
		echo 'ADICIONAR USUARIOS'
		echo '----------------------digite [0] para sair---'

		echo ''
		echo '[1] - ADM'
		echo '[2] - Empregado'
		echo '[3] - Estagiario'
		echo ''

		echo -n 'Digite o numero do cargo do funcionario: '
		read cargo

		#criar usuarios de acordo com o cargo
		case $cargo in

		#ADM
		"1")
			echo -n 'Digite o nome do usuario: '
			read name
			if [ $name -eq '0' ];
			then
				#starta novamente o programa
				echo '...'
			else
			#add user
			sudo useradd -m -d /etc/skel/$name -s /bin/bash $name
			clear

			#add senha
			echo 'Digite a senha do novo usuario'
			sudo passwd $name

			#trocar a senha no primeiro login
			sudo chage -d 0 $name

			#define conta sem data de expiracao
			sudo chage -E -1 $name

			#expira a senha em 60 dias
			sudo chage -M 60 $name

			#expira usuario inativo apos 120 dias
			sudo chage -i 120 $name

			#adicionar no grupo de adm
			sudo groupadd $name
			sudo usermod -g $name $name
			sudo usermod -aG admGroup $name
			sudo usermod -aG audio,video,storage,scanner $name

		fi

		./UserManager.su
		;;

		#empregado
		"2")
			echo -n 'Digite o nome do usuario: '
			read name
			if [ $name -eq '0' ];
			then
				#starta novamente o programa
				echo '...'
			else

			#add user
			sudo useradd -m -d /etc/temp_skel/$name -s /bin/bash $name
			clear

			#add senha
			echo 'Digite a senha do novo usuario'
			sudo passwd $name

			#trocar a senha no primeiro login
			sudo chage -d 0 $name


			#expira conta
			echo -n 'Digite quandos dias o usuario vai ter acesso: '
			read userdays
			sudo chage -E $(date -d "+$userdays days" +%y-%m-%d) $name

			#troca senha em 60 dias
			sudo chage -M 60 $name

			#muda aviso de 7 para 15
			sudo chage -W 15 $name

			#expira usuario inativo apos 120 dias
			sudo chage -i 120 $name

			#adicionar no grupo de empregado
			sudo usermod -g users $name
			sudo usermod -aG empregadoGroup $name
			sudo usermod -aG audio,video $name
		fi
		./UserManager.su
		;;

		#estagiario
		"3")
			echo -n 'Digite o nome do usuario: '
			read name


			if [ $name -eq '0' ];
			then
				#starta novamente o programa
				echo '...'
			else

			#add user
			sudo useradd $name -m
			clear

			#add senha
			echo 'Digite a senha do novo usuario'
			sudo passwd $name

			#trocar a senha no primeiro login
			sudo chage -d 0 $name

			#expira conta
			echo -n 'Digite quandos dias o usuario vai ter acesso: '
			read userdays
			sudo chage -E $(date -d "+$userdays days" +%y-%m-%d) $name

			#expira a senha em 60 dias
			sudo chage -M 60 $name

			#expira usuario inativo apos 120 dias
			sudo chage -i 120 $name

			#muda aviso de 7 para 15
			sudo chage -W 15 $name

			#adicionar no grupo de estagiario
			sudo usermod -g users $name
			sudo usermod -aG estagiarioGroup $name
			sudo usermod -aG audio,video $name
		fi

		./UserManager.su
		;;

		"0")
			./UserManager.su
		;;

		esac
	;;

	#informacoes do usuario
	"2")
		clear
		echo '---------------------------------------------'
		echo 	'INFORMACOES'
		echo '----------------------digite [0] para sair---'

		echo -n 'Usuarios: '
		ls /etc/skel
		ls /etc/temp_skel
		echo ''

		echo -n 'Digite o nome do usuario: '
		read name
		if [ $name -eq '0' ];
		then
			echo '...'
		else
			sudo chage -l $name
			echo ''
			echo -n 'Pressione enter para nontinuar... '
			read temp
		fi

		./UserManager.su
	;;

	"3")
		clear
		echo '---------------------------------------------'
		echo '	 GRUPOS USUARIO'
		echo '----------------------digite [0] para sair---'
		echo ''
		echo -n 'Usuarios: '
		ls /etc/skel
		ls /etc/temp_skel
		echo ''
		echo -n 'Digite o nome para ver os grupos: '
		read name
		groups $name
		if [ $name -eq '0' ];
		then
			echo '..'
		else
			clear
			echo -n 'Grupos: '
			groups $name

			echo ''
			echo -n 'Digite enter para continuar...' 
			read temp
		fi

		./UserManager.su
	;;


	#deletar usuario
	"9")
		clear
		echo '---------------------------------------------'
		echo '	 DELETAR USUARIOS'
		echo '----------------------digite [0] para sair---'
		echo ''
		echo -n 'Usuarios: '
		ls /etc/skel
		ls /etc/temp_skel
		echo ''
		echo -n 'Digite o nome para deletar: '
		read deletName

		if [ $deletName -eq '0' ];
		then
			echo ''
		else
			sudo deluser $deletName
			rm -r /etc/skel/$deletName
			rm -r /etc/temp_skel/$deletName
			echo 'Usuario deletado'
		fi

		./UserManager.su
	;;


	#sair do programa
	"0")
		clear
		echo "Tchau  :)"
		exit
	;;


#final do programa
esac


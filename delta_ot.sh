_tp_bin="/usr/sap/trans/bin"
_tp_cmd="/usr/sap/${SAPSYSTEMNAME}/SYS/exe/run/tp"
_tp_profile="$_tp_bin/TP_DOMAIN_SD1.PFL"


input=""
while IFS= read -r line
do
	echo "Transport de l'OT $line sur $SAPSYSTEMENAME"
	tp addtobuffer $line $SAPSYSTEMENAME pf=$_tp_profile
	_CR=$?
	if [[ $_CR -gt 7 ]];then
		echo "$line en erreur $_CR sur $SAPSYSTEMENAME"
		exit $_CR
	fi
	
	tp import $line $_SID u1234 pf=$_tp_profile
	
	if [[ $_CR -gt 7 ]];then
		echo "$line en erreur $_CR sur $SAPSYSTEMENAME"
		exit $_CR
	fi
done < "$input"
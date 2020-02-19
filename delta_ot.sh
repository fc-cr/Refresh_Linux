#*************************
#
#   Script de transport d'OT
#
#   Format du fichier:
#   <Num de l'ot>;<CR attendu>
#    SIDK000000;0
#
#*************************



read -p "Quel est le nom du fichier : " input
read -p "Quel est le nom du controleur de domaine : " _DC

_tp_bin="/usr/sap/trans/bin"
_tp_cmd="/usr/sap/${SAPSYSTEMNAME}/SYS/exe/run/tp"
_tp_profile="$_tp_bin/TP_DOMAIN_$_DC.PFL"

while IFS= read -r line
do
    _OT=$(echo $line | awk -F ';' '{print $1}' | sed 's/ //g')
    _CRatt=$(echo $line | awk -F ';' '{print $2}'| sed 's/ //g')
    if [[ -z _$CRatt ]];then
        echo "Transport de l'OT $_OT sur $SAPSYSTEMENAME"
    else
        echo "Transport de l'OT $_OT sur $SAPSYSTEMENAME avec CR attendu $_CRatt"
    fi

    tp addtobuffer $_OT $SAPSYSTEMENAME pf=$_tp_profile
    _CR=$?
    if [[ $_CR -gt 7 ]] && [[ ! -z _$CRatt ]] && [[ $_CR -ne _CRatt ]] ;then
                echo "$_OT en erreur $_CR sur $SAPSYSTEMENAME"
                exit $_CR
    fi

    tp import $_OT $_SID u1234 pf=$_tp_profile

    if [[ $_CR -gt 7 ]] && [[ ! -z _$CRatt ]] && [[ $_CR -ne _CRatt ]] ;then
                echo "$_OT en erreur $_CR sur $SAPSYSTEMENAME"
                exit $_CR
    fi
    echo "$_OT transporté avec CR $_CR"

done < "$input"
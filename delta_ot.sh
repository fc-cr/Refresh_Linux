_tp_bin="/usr/sap/trans/bin"
_tp_cmd="/usr/sap/${SAPSYSTEMNAME}/SYS/exe/run/tp"
_tp_profile="$_tp_bin/TP_DOMAIN_SD1.PFL"


input="test"
while IFS= read -r line
do
    _OT=$(echo $line | awk -F ';' '{print $1}' | sed 's/ //g')
    _CRatt=$(echo $line | awk -F ';' '{print $2}'| sed 's/ //g')
    echo "Transport de l'OT $_OT sur $SAPSYSTEMENAME avec CR attendu $_CRatt"
    tp addtobuffer $_OT $SAPSYSTEMENAME pf=$_tp_profile
    _CR=$?
    if [[ $_CR -gt 7 ]];then
        if [[ $_CR -ne _CRatt ]];then
            echo "$_OT en erreur $_CR sur $SAPSYSTEMENAME"
            exit $_CR
        fi
    fi

    tp import $_OT $_SID u1234 pf=$_tp_profile

    if [[ $_CR -gt 7 ]];then
        if [[ $_CR -ne _CRatt ]];then
            echo "$_OT en erreur $_CR sur $SAPSYSTEMENAME"
            exit $_CR
        fi
    fi
    echo "$_OT transporté avec CR $_CR"
done < "$input"
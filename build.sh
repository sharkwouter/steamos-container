#!/bin/bash
RELEASE="${1}"
BASE="${PWD}/${2}"
CHROOTPATH="${PWD}/chroot"
SCRIPT="${PWD}/${RELEASE}"
OUTPUT="${PWD}/${3}/${RELEASE}.tar.gz"

if [ ! -d ${BASE} ]; then
	echo "Error: ${BASE} directory not found, run gen.sh first"
fi
base_include="${BASE}/.disk/base_include"
base_exclude="${BASE}/.disk/base_exclude"

components=""
for component in `cat ${BASE}/.disk/base_components`; do
	if [ "${component}" == "main" ]; then
		components="${component}"
	else
		components="${components},${component}"
	fi
done

includes=""
if [ -f ${base_include} ]; then
	for include in `cat ${base_include}`; do
		includes="${includes},${include}"
		if [ "${include}" == "$(head -1 ${base_include})" ]; then
			includes="--include=${include}"
		else
			includes="${includes},${include}"
		fi
	done
fi

excludes=""
if [ -f ${base_exclude} ]; then
	for exclude in `cat ${base_exclude}`; do
		if [ "${exclude}" == "$(head -1 ${base_exclude})" ]; then
			excludes="--exclude=${exclude}"
		else
			excludes="${excludes},${exclude}"
		fi
	done
fi

debootstrap --foreign --components=${components} --resolve-deps ${includes} ${excludes} --no-check-gpg ${RELEASE} ${CHROOTPATH} file://${BASE} ${SCRIPT} && \
tar --exclude='dev/*' -cvf ${OUTPUT} -C ${CHROOTPATH} .

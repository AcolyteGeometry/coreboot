/*
 * This file is part of the coreboot project.
 *
 * Copyright (C) 2016 Google Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#include <variant/ec.h>
#include <variant/gpio.h>

#include <arch/acpi.h>
DefinitionBlock(
	"dsdt.aml",
	"DSDT",
	0x02,		// DSDT revision: ACPI v2.0 and up
	OEM_ID,
	ACPI_TABLE_CREATOR,
	0x20110725	// OEM revision
)
{
	/* Some generic macros */
	#include <soc/intel/skylake/acpi/platform.asl>

	/* global NVS and variables */
	#include <soc/intel/skylake/acpi/globalnvs.asl>

	/* CPU */
	#include <cpu/intel/common/acpi/cpu.asl>

	Scope (\_SB)
	{
		Device (PCI0)
		{
			/* Image processing unit */
			#include <soc/intel/skylake/acpi/ipu.asl>
			#include <soc/intel/skylake/acpi/systemagent.asl>
			#include <soc/intel/skylake/acpi/pch.asl>
		}
	}

#if IS_ENABLED(CONFIG_VARIANT_HAS_CAMERA_ACPI)
	/* Camera */
	#include <variant/acpi/camera.asl>
#endif

	/* Chrome OS specific */
	#include <vendorcode/google/chromeos/acpi/chromeos.asl>

	/* Chipset specific sleep states */
	#include <soc/intel/skylake/acpi/sleepstates.asl>

	/* Chrome OS Embedded Controller */
	Scope (\_SB.PCI0.LPCB)
	{
		/* ACPI code for EC SuperIO functions */
		#include <ec/google/chromeec/acpi/superio.asl>
		/* ACPI code for EC functions */
		#include <ec/google/chromeec/acpi/ec.asl>
	}

	Scope (\_SB)
	{
		/* Dynamic Platform Thermal Framework */
		#include <variant/acpi/dptf.asl>
	}
}

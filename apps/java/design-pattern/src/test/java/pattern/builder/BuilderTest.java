package pattern.builder;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class BuilderTest {

    @Test
    void desktopBuilderCreatesComputerWithCrtDisplay() {
        DesktopBuilder builder = new DesktopBuilder();
        builder.addHardDisk(10000);

        Computer computer = builder.getComputer();

        assertEquals("CRT", computer.display());
        assertNotNull(computer.motherboard());
        assertFalse(computer.drives().isEmpty());
    }

    @Test
    void laptopBuilderCreatesComputerWithLcdDisplay() {
        LaptopBuilder builder = new LaptopBuilder();
        builder.addHardDisk(5000);

        Computer computer = builder.getComputer();

        assertEquals("LCD", computer.display());
    }

    @Test
    void builderSupportsTurboCpu() {
        DesktopBuilder builder = new DesktopBuilder();
        builder.setTurbo(true);
        builder.addHardDisk(10000);

        Computer computer = builder.getComputer();

        assertEquals("TurboCPU", computer.motherboard().cpu());
    }

    @Test
    void builderValidatesMemorySize() {
        DesktopBuilder builder = new DesktopBuilder();
        builder.setMemorySize(100);
        builder.addHardDisk(10000);

        assertThrows(IllegalStateException.class, builder::getComputer);
    }

    @Test
    void builderValidatesTooManyDrives() {
        DesktopBuilder builder = new DesktopBuilder();
        builder.addHardDisk(10000);
        builder.addCd(false);
        builder.addDvd(false);
        builder.addCd(true);
        builder.addDvd(true);

        assertThrows(IllegalStateException.class, builder::getComputer);
    }

    @Test
    void builderValidatesMustHaveHardDisk() {
        DesktopBuilder builder = new DesktopBuilder();
        builder.addCd(false);

        assertThrows(IllegalStateException.class, builder::getComputer);
    }

    @Test
    void driveRecordHoldsProperties() {
        Drive drive = new Drive("hard_disk", 10000, true);

        assertEquals("hard_disk", drive.type());
        assertEquals(10000, drive.size());
        assertTrue(drive.writable());
    }
}

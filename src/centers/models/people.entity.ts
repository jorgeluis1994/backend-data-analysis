import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('dim_people') // Nombre de la tabla en la base de datos
export class DimPeople {
  @PrimaryGeneratedColumn('increment')
  id_people: number; // ID autoincremental (serial4 en la tabla)

  @Column({ type: 'varchar', length: 50 })
  center_identifier: string; // Identificador del centro (varchar(50))

  @Column({ type: 'varchar', length: 100 })
  person_identifier: string; // Identificador de la persona (varchar(100))

  @Column({ type: 'varchar', length: 25, nullable: true })
  gender: string | null; // Género de la persona (nullable)

  @Column({ type: 'date', nullable: true })
  date_of_birth: Date | null; // Fecha de nacimiento (nullable)

  @Column({ type: 'int', nullable: true })
  age: number | null; // Edad de la persona (nullable)

  @Column({ type: 'int', nullable: true })
  height_cm: number | null; // Altura en cm (nullable)
}

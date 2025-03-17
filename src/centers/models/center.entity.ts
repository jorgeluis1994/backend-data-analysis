import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('dim_centers') // Define el nombre de la tabla
export class DimCenter {
  @PrimaryGeneratedColumn('increment') // Especifica que es la clave primaria
  id_center: number;

  @Column({ type: 'varchar', length: 255, nullable: true })
  center_identifier: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  center_name: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  holder_cif_nif: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  holder_legal_personality: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  manager_cif_nif: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  manager_legal_personality: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  center_type: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  municipality: string;

  @Column({ type: 'varchar', length: 25, nullable: true })
  restriction_free_center: string;

  @Column({ type: 'int', nullable: true })
  num_authorized_places: number;

  @Column({ type: 'int', nullable: true })
  num_contracted_places: number;

  @Column({ type: 'varchar', length: 50, nullable: true })
  has_autonomous_places: string;

  @Column({ type: 'int', nullable: true })
  num_autonomous_places: number;

  @Column({ type: 'boolean', nullable: true })
  has_psychogeriatric_places: boolean;

  @Column({ type: 'int', nullable: true })
  num_psychogeriatric_places: number;

  @Column({ type: 'boolean', nullable: true })
  has_paliative_places: boolean;

  @Column({ type: 'int', nullable: true })
  num_paliative_places: number;

  @Column({ type: 'int', nullable: true })
  num_female_users: number;

  @Column({ type: 'int', nullable: true })
  num_users_over_65: number;

  @Column({ type: 'int', nullable: true })
  num_users_dependency_grade_1: number;

  @Column({ type: 'int', nullable: true })
  num_users_dependency_grade_2: number;

  @Column({ type: 'int', nullable: true })
  num_users_dependency_grade_3: number;

  @Column({ type: 'int', nullable: true })
  num_days_of_stay: number;

  @Column({ type: 'int', nullable: true })
  num_discharges: number;

  @Column({ type: 'int', nullable: true })
  num_deaths: number;
}

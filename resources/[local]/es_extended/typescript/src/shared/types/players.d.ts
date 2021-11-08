interface Bank {
  account_id: number;
  account_balance: number;
}

interface Faction {
  group?: {
    faction_name: string;
    member_count: number;
    max_members: number;

    garage?: number[];
    bank_account?: number;
  };
  member?: {
    rank_level: number;
    rank_name: string;
  };
}

interface License {
  id: number;
  license_id: number;
  license_name: string;
}

interface Character {
  /** CITIZEN/CHARACTER ID */
  cid: number;
  /** PLAYER ID */
  pid: number;
  first_name: string;
  last_name: string;
  job: string;
  /** 0 = FALSE, 1 = TRUE */
  dead: number;
  jail_time: number;
  phone_number: number;
  /** USED FOR POLICE, EMS ETC */
  onDuty: boolean;
  /** 0 = MALE, 1 = FEMALE */
  gender: 0 | 1;

  bank: Bank;
  faction: Faction;
  licenses: License[];
}

interface Player {
  /** PLAYER ID */
  pid: number;
  /** STEAM NAME */
  display_name: string;
  /** IN SECONDS */
  play_time: number;
  /** ADMIN PRIORITY LEVEL (USED IN JP-ADMIN) */
  admin_level: number | false;

  steam: string;
  license: string;
  license2: string;
}

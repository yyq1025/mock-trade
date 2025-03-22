import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseService {
  private admin: admin.app.App;

  onModuleInit() {
    this.admin = admin.initializeApp({
      credential: admin.credential.applicationDefault(),
    });
  }

  getAdmin() {
    return this.admin;
  }
}

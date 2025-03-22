import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { FirebaseService } from 'src/firebase/firebase.service';

@Injectable({})
export class FirebaseAuthGuard implements CanActivate {
  constructor(private readonly firebaseService: FirebaseService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    if (type !== 'Bearer' || !token) {
      return false;
    }
    try {
      const decodedToken = await this.firebaseService
        .getAdmin()
        .auth()
        .verifyIdToken(token);
      request.user = decodedToken;
      return true;
    } catch (error) {
      return false;
    }
  }
}

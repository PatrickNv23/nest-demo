import { BadRequestException, Injectable } from '@nestjs/common';
import { UserService } from '../user/user.service';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private jwtService: JwtService
  ) { }

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.userService.findOneByEmail(email);

    if (!user) {
      throw new BadRequestException('User not found');
    }

    const isMatch: boolean = bcrypt.compareSync(password, user.password_hash);

    if (!isMatch) {
      throw new BadRequestException('Password does not match');
    }
    return user;
  }

  async signIn(user: any) {
    const payload = {
      sub: user.userId,
      username: user.username,
      email: user.email
    };
    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }
}

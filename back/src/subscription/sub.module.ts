import { Module } from "@nestjs/common";
import { SubService } from "./sub.service";

@Module({
  imports: [],
  providers: [SubService],
  exports: [SubService],
  controllers: [],
})
export class SubModule {}

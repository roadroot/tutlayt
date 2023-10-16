import { Injectable } from "@nestjs/common";
import { PubSub } from "graphql-subscriptions";

@Injectable()
export class SubService {
  // TODO pubsub is not suited for production, use redis, rabbitmq, kafka, etc.

  readonly pubSub: PubSub = new PubSub();

  async subscribe<T>(
    triggerName: string,
    callback: (payload: T) => void
  ): Promise<number> {
    return await this.pubSub.subscribe(triggerName, callback);
  }

  unsubscribe(subId: number) {
    this.pubSub.unsubscribe(subId);
  }

  async publish(tag: string, payload: any): Promise<void> {
    const item: any = {};
    item[tag] = payload;
    await this.pubSub.publish(tag, item);
  }
}
